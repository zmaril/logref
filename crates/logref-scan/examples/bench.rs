//! Honest end-to-end measurement of the lowering + `RegexSet` scanner.
//!
//! There is no captured production Postgres log to hand, and standing one up is
//! heavy. Instead we *synthesize* a log from the catalog itself: take a shuffled
//! sample of sites that have a literal `message.text`, render each format string
//! with plausible concrete values ([`logref_core::render_sample`]), and scan the
//! result. Because we know which site produced each line, we can measure
//! round-trip fidelity — does a rendered line resolve back to *a* site, and to
//! the *correct* one — and how often it is ambiguous.
//!
//! This is NOT real server output. It measures lowering + matching, not which
//! messages Postgres actually emits.
//!
//! Run: `cargo run --release --example bench -- <catalog.jsonl> [N] [seed]`

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

fn main() -> anyhow::Result<()> {
    let mut args = std::env::args().skip(1);
    let path = args
        .next()
        .expect("usage: bench <catalog.jsonl> [N] [seed]");
    let n: usize = args.next().map(|s| s.parse().unwrap()).unwrap_or(5000);
    let seed: u64 = args
        .next()
        .map(|s| s.parse().unwrap())
        .unwrap_or(0x1234_5678);

    let raw = std::fs::read_to_string(&path)?;
    let index = Index::from_jsonl(&raw)?;

    let t0 = Instant::now();
    let (scanner, report) = Scanner::build(&index)?;
    let build_ms = t0.elapsed().as_secs_f64() * 1e3;

    println!("== build ==");
    println!("catalog sites          : {}", report.total);
    println!("  with literal text    : {}", report.total - report.no_text);
    println!("  computed-only (skip) : {}", report.no_text);
    println!("  lowering failed      : {}", report.lower_failed);
    println!("  regex compile failed : {}", report.compile_failed);
    println!("RegexSet patterns      : {}", scanner.pattern_count());
    println!("build wall-clock       : {build_ms:.1} ms");

    // How many patterns are bare catch-alls (literal_len == 0, e.g. "%s") — the
    // dominant ambiguity driver.
    let catchalls = index
        .sites
        .iter()
        .filter_map(|s| s.message.text.as_deref())
        .filter(|t| !t.is_empty())
        .filter_map(|t| logref_core::lower_format(t).ok())
        .filter(|l| l.literal_len == 0)
        .count();
    println!("zero-literal patterns  : {catchalls}  (match essentially anything)");

    // Duplicate format strings: many sites share the same text, so an exact
    // *site* match is a coin flip among duplicates even when the *message* is
    // resolved correctly.
    let mut texts: Vec<&str> = index
        .sites
        .iter()
        .filter_map(|s| s.message.text.as_deref())
        .filter(|t| !t.is_empty())
        .collect();
    let with_text = texts.len();
    texts.sort_unstable();
    texts.dedup();
    println!(
        "distinct format strings: {} of {with_text}  ({} sites share a duplicate text)",
        texts.len(),
        with_text - texts.len(),
    );

    // Synthesize the sample log: shuffled renderable sites.
    let mut renderable: Vec<(usize, String)> = index
        .sites
        .iter()
        .enumerate()
        .filter_map(|(i, s)| {
            let t = s.message.text.as_deref()?;
            if t.is_empty() {
                return None;
            }
            Some((i, render_sample(t)?))
        })
        .collect();
    let mut rng = Rng(seed);
    for i in (1..renderable.len()).rev() {
        let j = (rng.next() % (i as u64 + 1)) as usize;
        renderable.swap(i, j);
    }
    let sample = &renderable[..n.min(renderable.len())];
    let bytes: usize = sample.iter().map(|(_, l)| l.len() + 1).sum();

    println!("\n== synthesized log (NOT real server output) ==");
    println!("lines                  : {}", sample.len());
    println!("size                   : {:.3} MB", bytes as f64 / 1e6);

    let mut matched = 0usize;
    let mut correct_exact = 0usize; // truth site is the top-ranked hit
    let mut correct_text = 0usize; // top hit's format text == truth's (handles dup formats)
    let mut ambiguous = 0usize;
    // Same measures if we ignore the zero-literal catch-alls (the "require >=1
    // literal anchor char" policy the design notes float).
    let mut matched_nontrivial = 0usize;
    let mut ambiguous_nontrivial = 0usize;
    let mut examples: Vec<String> = Vec::new();
    let mut ambig_examples: Vec<String> = Vec::new();

    let t1 = Instant::now();
    for (truth, line) in sample {
        let hits = scanner.scan_line(line);
        let nontrivial = hits.iter().filter(|h| h.literal_len > 0).count();
        if nontrivial > 0 {
            matched_nontrivial += 1;
        }
        if nontrivial > 1 {
            ambiguous_nontrivial += 1;
        }
        if hits.is_empty() {
            continue;
        }
        matched += 1;
        let top = &hits[0];
        if top.site == *truth {
            correct_exact += 1;
        }
        let truth_text = index.sites[*truth].message.text.as_deref();
        if index.sites[top.site].message.text.as_deref() == truth_text {
            correct_text += 1;
        }
        if hits.len() > 1 {
            ambiguous += 1;
            if ambig_examples.len() < 2 && hits.len() >= 3 {
                let s = &index.sites[top.site];
                ambig_examples.push(format!(
                    "  line: {line:?}\n    matched {} sites; top = {} {:?} captures={:?}",
                    hits.len(),
                    s.location(),
                    s.message.display().unwrap_or(""),
                    top.captures,
                ));
            }
        } else if examples.len() < 4 && !top.captures.is_empty() && top.site == *truth {
            let s = &index.sites[top.site];
            examples.push(format!(
                "  line: {line:?}\n    -> {} {} {}  {:?}  captures={:?}",
                s.location(),
                s.api,
                s.level.as_deref().unwrap_or("-"),
                s.message.display().unwrap_or(""),
                top.captures,
            ));
        }
    }
    let scan_s = t1.elapsed().as_secs_f64();
    let total = sample.len();
    let pct = |x: usize| 100.0 * x as f64 / total as f64;

    println!("\n== scan ==");
    println!(
        "throughput             : {:.0} lines/s, {:.3} MB/s ({scan_s:.3} s)",
        total as f64 / scan_s,
        (bytes as f64 / 1e6) / scan_s,
    );
    println!("matched >=1 site       : {matched} ({:.1}%)", pct(matched));
    println!(
        "top hit == source site : {correct_exact} ({:.1}%)",
        pct(correct_exact)
    );
    println!(
        "top hit == source text : {correct_text} ({:.1}%)  [counts duplicate formats as correct]",
        pct(correct_text)
    );
    println!(
        "ambiguous (>1 site)    : {ambiguous} ({:.1}%)",
        pct(ambiguous)
    );
    println!(
        "  ignoring catch-alls  : matched {matched_nontrivial} ({:.1}%), \
         ambiguous {ambiguous_nontrivial} ({:.1}%)",
        pct(matched_nontrivial),
        pct(ambiguous_nontrivial),
    );

    println!("\n== example resolutions ==");
    for e in &examples {
        println!("{e}");
    }
    println!("\n== ambiguous examples ==");
    for e in &ambig_examples {
        println!("{e}");
    }
    Ok(())
}
