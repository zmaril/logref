//! Head-to-head native throughput: the **specialized matcher** behind
//! `scan_line` (anchored Aho-Corasick candidates + regex-free verification) vs
//! the **trigram-prefiltered** `scan_line_trigram` vs the exhaustive
//! **`RegexSet`** `scan_line_regexset`, over a synthesized log at ~4k-pattern
//! scale.
//!
//! The corpus is built exactly like the WASM browser benchmark's
//! (`crates/logref-wasm/bench/gen-catalog.ts`): replicate every real
//! `pg-catalog-sample.jsonl` site under a unique discriminating literal prefix
//! (`svcR.modN: …`) until we reach ~4000 patterns, so the patterns stay real
//! `printf` strings with real `%`-specs but the catalog grows to production
//! scale — the size at which trigram-prefilter vs RegexSet scaling diverges.
//!
//! All three paths return identical hits (the `resolve.rs` equivalence test
//! proves it); this measures ONLY the speed difference each strategy buys.
//!
//! Run: `cargo run --release --example bench_trigram -- [catalog.jsonl] [N] [seed]`
//! (catalog defaults to `snippets/pg-catalog-sample.jsonl`).

use std::time::Instant;

use logref_core::{render_sample, Index, Scanner};

/// Tiny deterministic xorshift so the sample is reproducible without an rng dep.
struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x
    }
}

const TARGET: usize = 4000;

fn main() -> anyhow::Result<()> {
    let mut args = std::env::args().skip(1);
    let path = args.next().unwrap_or_else(|| {
        format!(
            "{}/../../snippets/pg-catalog-sample.jsonl",
            env!("CARGO_MANIFEST_DIR")
        )
    });
    let n: usize = args.next().map(|s| s.parse().unwrap()).unwrap_or(20000);
    let seed: u64 = args
        .next()
        .map(|s| s.parse().unwrap())
        .unwrap_or(0x1234_5678);

    // ── build the ~4k-pattern corpus (mirrors bench/gen-catalog.ts) ──
    let raw = std::fs::read_to_string(&path)?;
    let base = Index::from_jsonl(&raw)?;
    let with_text: Vec<&str> = base
        .sites
        .iter()
        .filter_map(|s| s.message.text.as_deref())
        .filter(|t| !t.is_empty())
        .collect();

    let mut jsonl = String::new();
    let mut count = 0usize;
    'outer: for r in 0..1000 {
        for text in &with_text {
            let site = serde_json::json!({
                "api": "elog",
                "kind": "backend",
                "message": { "text": format!("svc{r}.mod{}: {text}", count % 37) },
                "path": "synthetic.c",
                "line": count + 1,
            });
            jsonl.push_str(&serde_json::to_string(&site)?);
            jsonl.push('\n');
            count += 1;
            if count >= TARGET {
                break 'outer;
            }
        }
    }
    let index = Index::from_jsonl(&jsonl)?;

    let (scanner, report) = Scanner::build(&index)?;
    println!("== corpus ==");
    println!("patterns (4k scale)    : {}", report.compiled);
    println!("always-check (no tri.) : {}", scanner.always_check_count());

    // ── synthesize the log: one rendered line per site, shuffled, cycled to N ──
    let mut renderable: Vec<String> = index
        .sites
        .iter()
        .filter_map(|s| s.message.text.as_deref())
        .filter_map(render_sample)
        .map(|l| l.replace('\n', " "))
        .collect();
    let mut rng = Rng(seed);
    for i in (1..renderable.len()).rev() {
        let j = (rng.next() % (i as u64 + 1)) as usize;
        renderable.swap(i, j);
    }
    let lines: Vec<&str> = (0..n)
        .map(|i| renderable[i % renderable.len()].as_str())
        .collect();
    let bytes: usize = lines.iter().map(|l| l.len() + 1).sum();
    println!("log lines (N)          : {n}");
    println!("size                   : {:.3} MB", bytes as f64 / 1e6);
    let cand: usize = lines.iter().map(|l| scanner.candidate_count(l)).sum();
    println!(
        "avg candidates / line  : {:.1} of {} patterns (trigram prefilter)",
        cand as f64 / lines.len() as f64,
        report.compiled,
    );
    let cand_spec: usize = lines.iter().map(|l| scanner.candidate_count_spec(l)).sum();
    println!(
        "avg candidates / line  : {:.2} of {} patterns (specialized AC anchors)",
        cand_spec as f64 / lines.len() as f64,
        report.compiled,
    );

    // warm-up (not timed) — touch all paths and confirm they agree.
    for line in lines.iter().take(500) {
        let a = scanner.scan_line(line);
        let b = scanner.scan_line_regexset(line);
        let c = scanner.scan_line_trigram(line);
        assert_eq!(a.len(), b.len(), "specialized dropped a match on {line:?}");
        assert_eq!(c.len(), b.len(), "prefilter dropped a match on {line:?}");
    }

    // ── time the RegexSet path ──
    let mut rs_hits = 0usize;
    let t = Instant::now();
    for line in &lines {
        rs_hits += scanner.scan_line_regexset(line).len();
    }
    let rs_s = t.elapsed().as_secs_f64();

    // ── time the trigram path ──
    let mut tri_hits = 0usize;
    let t = Instant::now();
    for line in &lines {
        tri_hits += scanner.scan_line_trigram(line).len();
    }
    let tri_s = t.elapsed().as_secs_f64();

    // ── time the specialized matcher (the scan_line default) ──
    let mut spec_hits = 0usize;
    let t = Instant::now();
    for line in &lines {
        spec_hits += scanner.scan_line(line).len();
    }
    let spec_s = t.elapsed().as_secs_f64();

    assert_eq!(rs_hits, tri_hits, "hit counts must match");
    assert_eq!(rs_hits, spec_hits, "hit counts must match");

    let rs_lps = n as f64 / rs_s;
    let tri_lps = n as f64 / tri_s;
    let spec_lps = n as f64 / spec_s;
    println!("\n== throughput (lines/sec) ==");
    println!("RegexSet    (scan_line_regexset): {rs_lps:>12.0}  ({rs_s:.3} s, {rs_hits} hits)",);
    println!("Trigram     (scan_line_trigram) : {tri_lps:>12.0}  ({tri_s:.3} s, {tri_hits} hits)",);
    println!(
        "Specialized (scan_line)         : {spec_lps:>12.0}  ({spec_s:.3} s, {spec_hits} hits)",
    );
    println!("speedup (trigram / regexset)    : {:.1}×", tri_lps / rs_lps);
    println!(
        "speedup (specialized / trigram) : {:.1}×",
        spec_lps / tri_lps
    );
    println!(
        "speedup (specialized / regexset): {:.1}×",
        spec_lps / rs_lps
    );
    Ok(())
}
