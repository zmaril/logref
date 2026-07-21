//! Integration test for the `resolve` path over committed fixtures: a small
//! log-site index plus a synthesized sample log. Exercises loading from disk,
//! building the scanner, and resolving each rendered line back to its site —
//! including specificity ranking against the bare `%s` catch-all.

use logref_core::{render_sample, Index, MatchHit, Scanner};

fn fixture(name: &str) -> String {
    let path = format!("{}/tests/fixtures/{name}", env!("CARGO_MANIFEST_DIR"));
    std::fs::read_to_string(&path).unwrap_or_else(|e| panic!("reading {path}: {e}"))
}

/// Two `MatchHit` vecs are field-for-field identical (site, literal_len,
/// captures, and order).
fn hits_eq(a: &[MatchHit], b: &[MatchHit]) -> bool {
    a.len() == b.len()
        && a.iter().zip(b).all(|(x, y)| {
            x.site == y.site && x.literal_len == y.literal_len && x.captures == y.captures
        })
}

#[test]
fn resolves_sample_log_against_fixture_index() {
    let index = Index::from_jsonl(&fixture("sites.jsonl")).unwrap();
    let (scanner, report) = Scanner::build(&index).unwrap();

    // 7 sites in, one is computed-only (`expr`, no literal text) → skipped.
    assert_eq!(report.total, 7);
    assert_eq!(report.no_text, 1);
    assert_eq!(report.compiled, 6);
    assert_eq!(report.lower_failed, 0);
    assert_eq!(report.compile_failed, 0);

    // (rendered line, expected most-specific format text, expected captures)
    let cases: &[(&str, &str, &[&str])] = &[
        (
            "database \"orders\" does not exist",
            "database \"%s\" does not exist",
            &["orders"],
        ),
        (
            "could not open file \"pg_wal/000000010000000000000001\": No such file or directory",
            "could not open file \"%s\": %m",
            &[
                "pg_wal/000000010000000000000001",
                "No such file or directory",
            ],
        ),
        ("7 of 512 tuples", "%d of %d tuples", &["7", "512"]),
        (
            "relation \"users\" already exists",
            "relation \"%s\" already exists",
            &["users"],
        ),
        ("disk is 90% full", "disk is %d%% full", &["90"]),
    ];

    for (line, expected_text, expected_caps) in cases {
        let hits = scanner.scan_line(line);
        assert!(!hits.is_empty(), "no hit for {line:?}");
        // The bare "%s" catch-all also matches every line, so each is ambiguous,
        // but the specific site must rank first by literal length.
        assert!(hits.len() >= 2, "{line:?} should also hit the catch-all");
        let top = &hits[0];
        assert_eq!(
            index.sites[top.site].message.text.as_deref(),
            Some(*expected_text),
            "wrong top site for {line:?}",
        );
        assert_eq!(top.captures, *expected_caps, "wrong captures for {line:?}");
    }

    // A line with no specific site resolves only to the bare catch-all.
    let hits = scanner.scan_line("this line matches no specific site and only the bare catch-all");
    assert_eq!(hits.len(), 1);
    assert_eq!(
        index.sites[hits[0].site].message.text.as_deref(),
        Some("%s")
    );
}

/// The critical guarantee: BOTH fast paths — the specialized matcher behind
/// `scan_line` (anchored Aho-Corasick candidates + regex-free verification) and
/// the retained trigram-prefiltered `scan_line_trigram` — return EXACTLY the
/// same `Vec<MatchHit>` (site, literal_len, captures, order) as the exhaustive
/// `RegexSet` oracle. The fast paths are pure speed optimizations and must
/// never drop, add, or reorder a match. Cross-checked over:
///   * every rendered line in the `resolve` fixture cases, plus a few misses, and
///   * a line synthesized (via `render_sample`) from every site in the real
///     `snippets/pg-catalog-sample.jsonl` catalog.
#[test]
fn fast_paths_match_regexset_over_fixtures_and_pg_catalog() {
    let mut checked = 0usize;

    // ── 1. the small resolve fixture index ──
    let index = Index::from_jsonl(&fixture("sites.jsonl")).unwrap();
    let (scanner, _) = Scanner::build(&index).unwrap();

    let mut lines: Vec<String> = vec![
        "database \"orders\" does not exist".into(),
        "could not open file \"pg_wal/000000010000000000000001\": No such file or directory".into(),
        "7 of 512 tuples".into(),
        "relation \"users\" already exists".into(),
        "disk is 90% full".into(),
        "this line matches no specific site and only the bare catch-all".into(),
        "".into(),
        "DATABASE \"X\" DOES NOT EXIST".into(),
    ];
    // Also add a rendered line for every site with literal text.
    for site in &index.sites {
        if let Some(t) = site.message.text.as_deref() {
            if let Some(r) = render_sample(t) {
                lines.push(r);
            }
        }
    }
    for line in &lines {
        let spec = scanner.scan_line(line);
        let tri = scanner.scan_line_trigram(line);
        let rs = scanner.scan_line_regexset(line);
        assert!(
            hits_eq(&spec, &rs),
            "fixture index diverged on {line:?}:\n  specialized={spec:?}\n  regexset={rs:?}"
        );
        assert!(
            hits_eq(&tri, &rs),
            "fixture index diverged on {line:?}:\n  trigram={tri:?}\n  regexset={rs:?}"
        );
        checked += 1;
    }

    // ── 2. the real pg-catalog sample: synthesize one line per site ──
    let catalog_path = format!(
        "{}/../../snippets/pg-catalog-sample.jsonl",
        env!("CARGO_MANIFEST_DIR")
    );
    let raw = std::fs::read_to_string(&catalog_path)
        .unwrap_or_else(|e| panic!("reading {catalog_path}: {e}"));
    let catalog = Index::from_jsonl(&raw).unwrap();
    let (cscan, report) = Scanner::build(&catalog).unwrap();
    assert!(
        report.compiled > 0,
        "pg-catalog sample compiled no patterns"
    );

    for site in &catalog.sites {
        let Some(text) = site.message.text.as_deref() else {
            continue;
        };
        let Some(line) = render_sample(text) else {
            continue;
        };
        // render_sample may emit embedded newlines for multi-line formats; scan
        // each physical line, exactly as a real log reader would.
        for phys in line.split('\n') {
            let spec = cscan.scan_line(phys);
            let tri = cscan.scan_line_trigram(phys);
            let rs = cscan.scan_line_regexset(phys);
            assert!(
                hits_eq(&spec, &rs),
                "pg-catalog diverged on {phys:?}:\n  specialized={spec:?}\n  regexset={rs:?}"
            );
            assert!(
                hits_eq(&tri, &rs),
                "pg-catalog diverged on {phys:?}:\n  trigram={tri:?}\n  regexset={rs:?}"
            );
            checked += 1;
        }
    }

    // ── 3. production scale: replicate the sample to ~4k patterns under unique
    // literal prefixes (mirrors bench/gen-catalog.ts), so the trigram buckets
    // are actually populated and contended — then cross-check a rendered line
    // per template against the exhaustive path. ──
    let with_text: Vec<&logref_core::LogSite> = catalog
        .sites
        .iter()
        .filter(|s| s.message.text.as_deref().is_some_and(|t| !t.is_empty()))
        .collect();
    let mut big = String::new();
    let mut n = 0usize;
    'outer: for r in 0..1000 {
        for s in &with_text {
            let text = s.message.text.as_deref().unwrap();
            let site = serde_json::json!({
                "api": s.api,
                "kind": "backend",
                "message": { "text": format!("svc{r}.mod{}: {text}", n % 37) },
                "path": s.path,
                "line": n + 1,
            });
            big.push_str(&serde_json::to_string(&site).unwrap());
            big.push('\n');
            n += 1;
            if n >= 4000 {
                break 'outer;
            }
        }
    }
    let big_index = Index::from_jsonl(&big).unwrap();
    let (bscan, breport) = Scanner::build(&big_index).unwrap();
    assert_eq!(breport.compiled, 4000, "expected a 4k-pattern corpus");
    for site in &big_index.sites {
        let text = site.message.text.as_deref().unwrap();
        let Some(line) = render_sample(text) else {
            continue;
        };
        for phys in line.split('\n') {
            let spec = bscan.scan_line(phys);
            let tri = bscan.scan_line_trigram(phys);
            let rs = bscan.scan_line_regexset(phys);
            assert!(
                hits_eq(&spec, &rs),
                "4k corpus diverged on {phys:?}:\n  specialized={spec:?}\n  regexset={rs:?}"
            );
            assert!(
                hits_eq(&tri, &rs),
                "4k corpus diverged on {phys:?}:\n  trigram={tri:?}\n  regexset={rs:?}"
            );
            checked += 1;
        }
    }

    assert!(
        checked >= 50,
        "expected to cross-check many lines, got {checked}"
    );
    eprintln!("equivalence cross-check: {checked} lines, specialized == trigram == regexset");
}
