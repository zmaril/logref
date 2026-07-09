//! `logref-scan` — resolve database log lines against a log-site index.
//!
//! Given an inventory (JSONL of [`logref_core::LogSite`]) and one or more log
//! messages, report the matching source sites. This is the CLI end of the
//! `Scan` surface described in `notes/design.md`; the matching is deliberately
//! simple for now (substring over decoded message text).

use std::fs;
use std::io::{self, Read};

use anyhow::{Context, Result};
use clap::{Parser, Subcommand};
use logref_core::Index;

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
