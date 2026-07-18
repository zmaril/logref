//! `logref-scan` — resolve database log lines against a log-site index.
//!
//! Given an inventory (JSONL of [`logref_core::LogSite`]) and one or more log
//! messages, report the matching source sites. This is the CLI end of the
//! `Scan` surface described in `notes/design.md`; the matching is deliberately
//! simple for now (substring over decoded message text).

use std::fs;
use std::io::{self, Read};
use std::time::Instant;

use anyhow::{Context, Result};
use clap::{Parser, Subcommand};
use logref_core::{Index, Scanner};

#[derive(Parser)]
#[command(name = "logref-scan", version, about)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Look up log lines against the index and print the source sites they
    /// most likely came from.
    Scan {
        /// Path to the log-site inventory (JSON Lines).
        #[arg(short, long)]
        index: String,
        /// Log line to resolve. Repeat for several; omit to read them from
        /// stdin, one per line.
        #[arg(short, long = "query")]
        queries: Vec<String>,
    },
    /// Resolve fully-rendered log lines back to their source call site by
    /// lowering every catalog format string to a regex and matching. Reads log
    /// lines from a file (or stdin) and reports, per line, the matching site(s)
    /// and the extracted variable bits; multiple matches are flagged ambiguous.
    Resolve {
        /// Path to the log-site inventory (JSON Lines).
        #[arg(short, long)]
        index: String,
        /// Log file to scan, one rendered line per line. Omit to read stdin.
        log: Option<String>,
        /// Suppress per-line output; print only the build report and summary.
        #[arg(short, long)]
        quiet: bool,
    },
    /// Report how many sites the index holds.
    Stats {
        #[arg(short, long)]
        index: String,
    },
}

fn load_index(path: &str) -> Result<Index> {
    let raw = fs::read_to_string(path).with_context(|| format!("reading index at {path}"))?;
    Index::from_jsonl(&raw).with_context(|| format!("parsing index at {path}"))
}

fn queries_from_stdin() -> Result<Vec<String>> {
    let mut buf = String::new();
    io::stdin()
        .read_to_string(&mut buf)
        .context("reading queries from stdin")?;
    Ok(buf
        .lines()
        .map(str::trim)
        .filter(|l| !l.is_empty())
        .map(String::from)
        .collect())
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    match cli.command {
        Command::Stats { index } => {
            let index = load_index(&index)?;
            println!("{} log sites", index.len());
        }
        Command::Resolve { index, log, quiet } => {
            let index = load_index(&index)?;

            let t0 = Instant::now();
            let (scanner, report) = Scanner::build(&index).context("building scanner")?;
            let build_ms = t0.elapsed().as_secs_f64() * 1e3;

            eprintln!(
                "built {} patterns from {} sites in {build_ms:.1} ms \
                 ({} no-text, {} lower-failed, {} compile-failed)",
                report.compiled,
                report.total,
                report.no_text,
                report.lower_failed,
                report.compile_failed,
            );

            let raw = match &log {
                Some(path) => {
                    fs::read_to_string(path).with_context(|| format!("reading log {path}"))?
                }
                None => {
                    let mut buf = String::new();
                    io::stdin()
                        .read_to_string(&mut buf)
                        .context("reading log from stdin")?;
                    buf
                }
            };

            let lines: Vec<&str> = raw.lines().filter(|l| !l.is_empty()).collect();
            let bytes = lines.iter().map(|l| l.len() + 1).sum::<usize>();

            let mut matched = 0usize;
            let mut ambiguous = 0usize;
            let t1 = Instant::now();
            for line in &lines {
                let hits = scanner.scan_line(line);
                if !hits.is_empty() {
                    matched += 1;
                }
                if hits.len() > 1 {
                    ambiguous += 1;
                }
                if quiet {
                    continue;
                }
                println!("{line}");
                if hits.is_empty() {
                    println!("  (no matching site)");
                    continue;
                }
                if hits.len() > 1 {
                    println!("  (ambiguous: {} sites)", hits.len());
                }
                for hit in &hits {
                    let site = &index.sites[hit.site];
                    let level = site.level.as_deref().unwrap_or("-");
                    let text = site.message.display().unwrap_or("<no message>");
                    println!(
                        "  {} {} {}  — {}  captures={:?}",
                        site.location(),
                        site.api,
                        level,
                        text,
                        hit.captures,
                    );
                }
            }
            let scan_s = t1.elapsed().as_secs_f64();
            let total = lines.len();
            let pct = |n: usize| {
                if total == 0 {
                    0.0
                } else {
                    100.0 * n as f64 / total as f64
                }
            };
            eprintln!(
                "scanned {total} lines ({:.2} MB) in {scan_s:.3} s: \
                 {:.0} lines/s, {:.1} MB/s",
                bytes as f64 / 1e6,
                total as f64 / scan_s.max(f64::MIN_POSITIVE),
                (bytes as f64 / 1e6) / scan_s.max(f64::MIN_POSITIVE),
            );
            eprintln!(
                "matched >=1: {matched} ({:.1}%), ambiguous: {ambiguous} ({:.1}%), \
                 unmatched: {} ({:.1}%)",
                pct(matched),
                pct(ambiguous),
                total - matched,
                pct(total - matched),
            );
        }
        Command::Scan { index, queries } => {
            let index = load_index(&index)?;
            let queries = if queries.is_empty() {
                queries_from_stdin()?
            } else {
                queries
            };
            for query in queries {
                let hits = index.search(&query);
                println!("{query}");
                if hits.is_empty() {
                    println!("  (no matching site)");
                }
                for hit in hits {
                    let level = hit.level.as_deref().unwrap_or("-");
                    let text = hit.message.display().unwrap_or("<no message>");
                    println!("  {} {} {}  — {}", hit.location(), hit.api, level, text);
                }
            }
        }
    }
    Ok(())
}
