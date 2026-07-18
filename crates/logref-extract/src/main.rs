//! `logref-extract` — mine Postgres log/error call sites into the logref inventory.
//!
//! Runs Semgrep (the rules in `snippets/semgrep-rules.yml`) over a Postgres C
//! source checkout, then parses each matched call's arguments into a structured
//! [`logref_core::LogSite`] and emits the inventory as JSON Lines — the shape
//! `logref-core::Index::from_jsonl` consumes. See `notes/design.md` (Stage 1).

use std::collections::BTreeMap;
use std::fs;
use std::io::{BufWriter, Write};
use std::path::{Path, PathBuf};
use std::process::Command;
use std::time::Instant;

use anyhow::{bail, Context, Result};
use clap::Parser;
use logref_extract::{build_site, parse_semgrep_json};

#[derive(Parser)]
#[command(name = "logref-extract", version, about)]
struct Cli {
    /// Path to the Semgrep rules file (e.g. `snippets/semgrep-rules.yml`).
    #[arg(short, long)]
    rules: PathBuf,

    /// Source target to scan (e.g. a Postgres checkout directory). Paths in the
    /// output are reported relative to the current directory, as Semgrep sees
    /// them.
    #[arg(short = 't', long)]
    target: PathBuf,

    /// Where to write the JSONL inventory. Omit for stdout.
    #[arg(short, long)]
    out: Option<PathBuf>,

    /// Reuse an existing `semgrep --json` output file instead of running Semgrep.
    #[arg(long)]
    semgrep_json: Option<PathBuf>,

    /// Semgrep binary to invoke.
    #[arg(long, default_value = "semgrep")]
    semgrep_bin: String,

    /// Directory the reported paths are relative to (for reading call text).
    #[arg(long, default_value = ".")]
    base: PathBuf,

    /// Number of Semgrep worker jobs.
    #[arg(short = 'j', long)]
    jobs: Option<usize>,

    /// Keep the intermediate Semgrep JSON here (otherwise a temp file is used).
    #[arg(long)]
    keep_json: Option<PathBuf>,
}

fn run_semgrep(cli: &Cli) -> Result<String> {
    let json_path = cli
        .keep_json
        .clone()
        .unwrap_or_else(|| std::env::temp_dir().join("logref-extract-semgrep.json"));

    let mut cmd = Command::new(&cli.semgrep_bin);
    cmd.arg("--config")
        .arg(&cli.rules)
        .arg("--json")
        .arg("--quiet")
        .arg("--no-git-ignore")
        .arg("--metrics")
        .arg("off")
        .arg("--output")
        .arg(&json_path);
    if let Some(j) = cli.jobs {
        cmd.arg("--jobs").arg(j.to_string());
    }
    cmd.arg(&cli.target);

    eprintln!(
        "running: {} --config {} --json … {}",
        cli.semgrep_bin,
        cli.rules.display(),
        cli.target.display()
    );
    let started = Instant::now();
    let status = cmd
        .status()
        .with_context(|| format!("spawning semgrep ({})", cli.semgrep_bin))?;
    let elapsed = started.elapsed();
    eprintln!("semgrep finished in {:.1}s", elapsed.as_secs_f64());
    if !status.success() {
        bail!("semgrep exited with {status}");
    }
    fs::read_to_string(&json_path).with_context(|| format!("reading {}", json_path.display()))
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    let json = match &cli.semgrep_json {
        Some(p) => {
            eprintln!("using existing semgrep json: {}", p.display());
            fs::read_to_string(p).with_context(|| format!("reading {}", p.display()))?
        }
        None => run_semgrep(&cli)?,
    };

    let base = cli.base.clone();
    let matches = parse_semgrep_json(&json, |path| {
        let full = Path::new(&base).join(path);
        fs::read(&full).with_context(|| format!("reading source {}", full.display()))
    })
    .context("parsing semgrep json")?;

    // Build sites, and tally stats as we go.
    let mut by_api: BTreeMap<String, usize> = BTreeMap::new();
    let mut by_level: BTreeMap<String, usize> = BTreeMap::new();
    let mut by_kind: BTreeMap<String, usize> = BTreeMap::new();
    let mut literal = 0usize;
    let mut computed = 0usize;

    let out_writer: Box<dyn Write> = match &cli.out {
        Some(p) => {
            if let Some(parent) = p.parent() {
                if !parent.as_os_str().is_empty() {
                    fs::create_dir_all(parent).ok();
                }
            }
            Box::new(fs::File::create(p).with_context(|| format!("creating {}", p.display()))?)
        }
        None => Box::new(std::io::stdout()),
    };
    let mut w = BufWriter::new(out_writer);

    let total = matches.len();
    for m in matches {
        let site = build_site(
            &m.rule,
            &m.call,
            m.path,
            m.start_line,
            m.start_col,
            m.end_line,
            m.end_col,
        );

        *by_api.entry(site.api.clone()).or_default() += 1;
        *by_level
            .entry(site.level.clone().unwrap_or_else(|| "-".to_string()))
            .or_default() += 1;
        *by_kind
            .entry(format!("{:?}", site.kind).to_lowercase())
            .or_default() += 1;
        if site.message.text.is_some() {
            literal += 1;
        } else {
            computed += 1;
        }

        let line = serde_json::to_string(&site)?;
        w.write_all(line.as_bytes())?;
        w.write_all(b"\n")?;
    }
    w.flush()?;

    eprintln!("\n== extracted {total} log call sites ==");
    eprintln!("\nby api:");
    let mut api_sorted: Vec<_> = by_api.iter().collect();
    api_sorted.sort_by(|a, b| b.1.cmp(a.1));
    for (k, v) in api_sorted {
        eprintln!("  {v:>6}  {k}");
    }
    eprintln!("\nby kind:");
    for (k, v) in &by_kind {
        eprintln!("  {v:>6}  {k}");
    }
    eprintln!("\nby level:");
    let mut lvl_sorted: Vec<_> = by_level.iter().collect();
    lvl_sorted.sort_by(|a, b| b.1.cmp(a.1));
    for (k, v) in lvl_sorted {
        eprintln!("  {v:>6}  {k}");
    }
    eprintln!("\nmessage: {literal} literal, {computed} computed/non-literal");
    if let Some(p) = &cli.out {
        eprintln!("\nwrote {total} records to {}", p.display());
    }

    Ok(())
}
