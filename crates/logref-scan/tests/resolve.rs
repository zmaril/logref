//! Integration test for the `resolve` path over committed fixtures: a small
//! log-site index plus a synthesized sample log. Exercises loading from disk,
//! building the scanner, and resolving each rendered line back to its site —
//! including specificity ranking against the bare `%s` catch-all.

use logref_core::{Index, Scanner};

fn fixture(name: &str) -> String {
    let path = format!("{}/tests/fixtures/{name}", env!("CARGO_MANIFEST_DIR"));
    std::fs::read_to_string(&path).unwrap_or_else(|e| panic!("reading {path}: {e}"))
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
