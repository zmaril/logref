//! Extraction logic for Postgres log call sites.
//!
//! Semgrep tells us *where* a log call is (`file:line:col` + the verbatim call
//! text). This module turns that verbatim C call text into a structured
//! [`logref_core::LogSite`]: it peels the logging API's argument structure
//! (`errmsg`/`errdetail`/`errhint`/`errcode`, `gettext`/`_()` wrappers, adjacent
//! string-literal concatenation) to recover the literal message, severity,
//! SQLSTATE(s) and sub-messages.
//!
//! The parsing here is a small, string-aware C-argument walker — deliberately
//! not a full C parser. It is pure and dependency-free so it can be unit-tested
//! against representative snippets without Semgrep or a Postgres checkout.

use logref_core::{Kind, LogSite, Message};
use serde::Deserialize;

/// A single Semgrep match, distilled to what the extractor needs.
#[derive(Debug, Clone)]
pub struct RawMatch {
    /// Short rule key (last dotted segment of Semgrep's `check_id`).
    pub rule: String,
    /// Path as Semgrep reported it (relative to the invocation cwd).
    pub path: String,
    pub start_line: u32,
    pub start_col: u32,
    pub end_line: u32,
    pub end_col: u32,
    /// The verbatim source text of the matched call.
    pub call: String,
}

// ---------------------------------------------------------------------------
// Semgrep JSON
// ---------------------------------------------------------------------------

#[derive(Deserialize)]
struct SgOutput {
    results: Vec<SgResult>,
}

#[derive(Deserialize)]
struct SgResult {
    check_id: String,
    path: String,
    start: SgPos,
    end: SgPos,
}

#[derive(Deserialize)]
struct SgPos {
    line: u32,
    col: u32,
    offset: usize,
}

/// The last dotted segment of a Semgrep `check_id`. Semgrep namespaces a rule id
/// by its config-file path (e.g. `workspace.logref.snippets.postgres-ereport`);
/// the trailing segment is the stable rule id we authored.
pub fn rule_key(check_id: &str) -> &str {
    check_id.rsplit('.').next().unwrap_or(check_id)
}

/// Parse Semgrep's `--json` output into [`RawMatch`]es, slicing each call's
/// verbatim text out of the on-disk source via the reported byte offsets.
///
/// `read_source` maps a Semgrep-reported path to that file's bytes; it is a
/// closure so callers control I/O (and tests can supply in-memory sources).
pub fn parse_semgrep_json<F>(json: &str, mut read_source: F) -> anyhow::Result<Vec<RawMatch>>
where
    F: FnMut(&str) -> anyhow::Result<Vec<u8>>,
{
    let out: SgOutput = serde_json::from_str(json)?;
    let mut cache: Option<(String, Vec<u8>)> = None;
    let mut matches = Vec::with_capacity(out.results.len());
    for r in out.results {
        let bytes = match &cache {
            Some((p, b)) if *p == r.path => b,
            _ => {
                let b = read_source(&r.path)?;
                cache = Some((r.path.clone(), b));
                &cache.as_ref().unwrap().1
            }
        };
        let call = bytes
            .get(r.start.offset..r.end.offset)
            .map(|s| String::from_utf8_lossy(s).into_owned())
            .unwrap_or_default();
        matches.push(RawMatch {
            rule: rule_key(&r.check_id).to_string(),
            path: r.path,
            start_line: r.start.line,
            start_col: r.start.col,
            end_line: r.end.line,
            end_col: r.end.col,
            call,
        });
    }
    Ok(matches)
}

// ---------------------------------------------------------------------------
// Call-text parsing
// ---------------------------------------------------------------------------

fn is_ident_start(c: u8) -> bool {
    c == b'_' || c.is_ascii_alphabetic()
}
fn is_ident_char(c: u8) -> bool {
    c == b'_' || c.is_ascii_alphanumeric()
}

/// Given `bytes[i]` is a `"` or `'`, return the index just past the closing
/// (unescaped) quote of the same kind.
fn skip_literal(bytes: &[u8], mut i: usize) -> usize {
    let quote = bytes[i];
    i += 1;
    while i < bytes.len() {
        match bytes[i] {
            b'\\' => i += 2,
            c if c == quote => return i + 1,
            _ => i += 1,
        }
    }
    i
}

/// Given `bytes[open]` is `(`, return `(inner, index_after_close)` where `inner`
/// is the balanced content between the parens (strings/chars respected).
fn capture_parens(bytes: &[u8], open: usize) -> (String, usize) {
    let mut depth = 0usize;
    let mut i = open;
    let start_inner = open + 1;
    while i < bytes.len() {
        match bytes[i] {
            b'"' | b'\'' => {
                i = skip_literal(bytes, i);
                continue;
            }
            b'(' => depth += 1,
            b')' => {
                depth -= 1;
                if depth == 0 {
                    let inner = String::from_utf8_lossy(&bytes[start_inner..i]).into_owned();
                    return (inner, i + 1);
                }
            }
            _ => {}
        }
        i += 1;
    }
    (
        String::from_utf8_lossy(&bytes[start_inner..]).into_owned(),
        bytes.len(),
    )
}

/// The leading identifier of `s` (e.g. the callee name of a call expression).
pub fn leading_ident(s: &str) -> Option<&str> {
    let b = s.as_bytes();
    let mut i = 0;
    while i < b.len() && b[i].is_ascii_whitespace() {
        i += 1;
    }
    if i >= b.len() || !is_ident_start(b[i]) {
        return None;
    }
    let start = i;
    while i < b.len() && is_ident_char(b[i]) {
        i += 1;
    }
    Some(&s[start..i])
}

/// If `s` is exactly a single call `name( … )` (only whitespace after the close),
/// return `(name, inner_args)`.
fn as_call(s: &str) -> Option<(&str, String)> {
    let name = leading_ident(s)?;
    let b = s.as_bytes();
    let mut i = name.as_ptr() as usize - s.as_ptr() as usize + name.len();
    while i < b.len() && b[i].is_ascii_whitespace() {
        i += 1;
    }
    if i >= b.len() || b[i] != b'(' {
        return None;
    }
    let (inner, after) = capture_parens(b, i);
    if s[after..].trim().is_empty() {
        Some((name, inner))
    } else {
        None
    }
}

/// Split a comma-separated argument list at top level (depth 0), respecting
/// nested parens/brackets/braces and string/char literals. Empty input yields no
/// args. Returned args are trimmed.
pub fn split_top_level_args(s: &str) -> Vec<String> {
    let b = s.as_bytes();
    let mut args = Vec::new();
    let mut depth = 0i32;
    let mut start = 0usize;
    let mut i = 0usize;
    let mut saw_any = false;
    while i < b.len() {
        match b[i] {
            b'"' | b'\'' => {
                saw_any = true;
                i = skip_literal(b, i);
                continue;
            }
            b'(' | b'[' | b'{' => depth += 1,
            b')' | b']' | b'}' => depth -= 1,
            b',' if depth == 0 => {
                args.push(s[start..i].trim().to_string());
                start = i + 1;
                saw_any = true;
                i += 1;
                continue;
            }
            c if !c.is_ascii_whitespace() => saw_any = true,
            _ => {}
        }
        i += 1;
    }
    let tail = s[start..].trim();
    if !tail.is_empty() || (saw_any && !args.is_empty()) {
        args.push(tail.to_string());
    }
    args
}

/// Find every top-level-or-nested call to one of `names` inside `body`, in
/// source order, returning `(name, inner_args)`. Name matching is exact (word
/// boundary before, `(` immediately after modulo whitespace) and string-aware,
/// so `errdetail` does not match `errdetail_relkind_not_supported` and `errmsg`
/// does not match `errmsg_internal`.
pub fn find_calls(body: &str, names: &[&str]) -> Vec<(String, String)> {
    let b = body.as_bytes();
    let mut out = Vec::new();
    let mut i = 0usize;
    while i < b.len() {
        let c = b[i];
        if c == b'"' || c == b'\'' {
            i = skip_literal(b, i);
            continue;
        }
        if is_ident_start(c) && (i == 0 || !is_ident_char(b[i - 1])) {
            let start = i;
            while i < b.len() && is_ident_char(b[i]) {
                i += 1;
            }
            let ident = &body[start..i];
            let mut j = i;
            while j < b.len() && b[j].is_ascii_whitespace() {
                j += 1;
            }
            if j < b.len() && b[j] == b'(' && names.contains(&ident) {
                let (inner, after) = capture_parens(b, j);
                out.push((ident.to_string(), inner));
                i = after;
            }
            continue;
        }
        i += 1;
    }
    out
}

/// Decode one C string literal body (the text *between* the quotes) into its
/// runtime value, resolving the common escape sequences.
fn decode_c_string(inner: &str) -> String {
    let b = inner.as_bytes();
    let mut out = String::with_capacity(inner.len());
    let mut i = 0usize;
    while i < b.len() {
        if b[i] != b'\\' {
            // Copy a whole UTF-8 char.
            let ch_len = utf8_len(b[i]);
            let end = (i + ch_len).min(b.len());
            out.push_str(&inner[i..end]);
            i = end;
            continue;
        }
        i += 1;
        if i >= b.len() {
            out.push('\\');
            break;
        }
        match b[i] {
            b'n' => out.push('\n'),
            b't' => out.push('\t'),
            b'r' => out.push('\r'),
            b'"' => out.push('"'),
            b'\'' => out.push('\''),
            b'\\' => out.push('\\'),
            b'0' if !(i + 1 < b.len() && b[i + 1].is_ascii_digit()) => out.push('\0'),
            b'a' => out.push('\u{07}'),
            b'b' => out.push('\u{08}'),
            b'f' => out.push('\u{0C}'),
            b'v' => out.push('\u{0B}'),
            b'x' => {
                let mut j = i + 1;
                let mut val: u32 = 0;
                while j < b.len() && (b[j] as char).is_ascii_hexdigit() {
                    val = val * 16 + (b[j] as char).to_digit(16).unwrap();
                    j += 1;
                }
                if j > i + 1 {
                    if let Some(c) = char::from_u32(val) {
                        out.push(c);
                    }
                    i = j;
                    continue;
                }
                out.push('x');
            }
            d if d.is_ascii_digit() => {
                let mut j = i;
                let mut val: u32 = 0;
                let mut count = 0;
                while j < b.len() && (b'0'..=b'7').contains(&b[j]) && count < 3 {
                    val = val * 8 + (b[j] - b'0') as u32;
                    j += 1;
                    count += 1;
                }
                if let Some(c) = char::from_u32(val) {
                    out.push(c);
                }
                i = j;
                continue;
            }
            other => out.push(other as char),
        }
        i += 1;
    }
    out
}

fn utf8_len(first: u8) -> usize {
    match first {
        b if b < 0x80 => 1,
        b if b >> 5 == 0b110 => 2,
        b if b >> 4 == 0b1110 => 3,
        b if b >> 3 == 0b11110 => 4,
        _ => 1,
    }
}

/// If `expr` is a pure run of adjacent C string literals (after peeling a
/// `gettext(...)`/`_(...)`/`dgettext(domain, …)` wrapper), decode and
/// concatenate them into the literal text. Returns `None` when the expression is
/// computed (a variable, a `psprintf`, a `%s` argument that is not itself a
/// literal, etc.) — that is an honest "no literal message here".
pub fn literal_text(expr: &str) -> Option<String> {
    let mut owned = expr.trim().to_string();

    // Peel translation wrappers, possibly nested.
    loop {
        let next = match as_call(owned.trim()) {
            Some((name, inner)) => match name {
                "_" | "gettext" | "gettext_noop" => Some(inner.trim().to_string()),
                "dgettext" | "dngettext" | "ngettext" => {
                    // dgettext(domain, msgid[, ...]) / ngettext(msgid, ...):
                    // the first *string-literal* argument is the message.
                    let a = split_top_level_args(&inner)
                        .into_iter()
                        .find(|a| a.trim_start().starts_with('"'))?;
                    Some(a.trim().to_string())
                }
                _ => None,
            },
            None => None,
        };
        match next {
            Some(n) => owned = n,
            None => break,
        }
    }

    parse_adjacent_literals(owned.trim())
}

/// Parse `s` as a sequence of one-or-more adjacent string literals separated only
/// by whitespace (C string-literal concatenation). Returns the decoded,
/// concatenated value, or `None` if `s` contains anything else.
fn parse_adjacent_literals(s: &str) -> Option<String> {
    let b = s.as_bytes();
    let mut i = 0usize;
    let mut out = String::new();
    let mut found = false;
    while i < b.len() {
        if b[i].is_ascii_whitespace() {
            i += 1;
            continue;
        }
        if b[i] != b'"' {
            return None;
        }
        let end = skip_literal(b, i); // index past closing quote
                                      // inner is between the quotes: [i+1 .. end-1]
        let inner = &s[i + 1..end - 1];
        out.push_str(&decode_c_string(inner));
        found = true;
        i = end;
    }
    if found {
        Some(out)
    } else {
        None
    }
}

fn message_from_expr(expr: &str) -> Message {
    let expr = expr.trim().to_string();
    let text = literal_text(&expr);
    Message {
        expr: if expr.is_empty() { None } else { Some(expr) },
        text,
    }
}

const ERRMSG_NAMES: &[&str] = &["errmsg", "errmsg_internal", "errmsg_plural"];
const ERRDETAIL_NAMES: &[&str] = &[
    "errdetail",
    "errdetail_internal",
    "errdetail_plural",
    "errdetail_log",
    "errdetail_log_plural",
];
const ERRHINT_NAMES: &[&str] = &["errhint", "errhint_plural", "errhint_internal"];
const ERRCONTEXT_NAMES: &[&str] = &["errcontext", "errcontext_msg"];
const ERRCODE_NAMES: &[&str] = &["errcode"];

fn first_arg(args: &str) -> String {
    split_top_level_args(args)
        .into_iter()
        .next()
        .unwrap_or_default()
}

/// Map a frontend `pg_log_*` / `pg_fatal` function name to its severity level.
fn frontend_level(api: &str) -> Option<&'static str> {
    let base = api.strip_suffix("_internal").unwrap_or(api);
    let base = base
        .strip_suffix("_detail")
        .or_else(|| base.strip_suffix("_hint"))
        .unwrap_or(base);
    match base {
        "pg_fatal" => Some("FATAL"),
        "pg_log_error" => Some("ERROR"),
        "pg_log_warning" => Some("WARNING"),
        "pg_log_info" => Some("INFO"),
        "pg_log_debug" => Some("DEBUG"),
        _ => None,
    }
}

fn frontend_part(api: &str) -> &'static str {
    if api.ends_with("_detail") {
        "detail"
    } else if api.ends_with("_hint") {
        "hint"
    } else {
        "primary"
    }
}

/// Turn one matched call into a structured [`LogSite`]. `rule` is the short rule
/// key (see [`rule_key`]); provenance is supplied by the caller.
#[allow(clippy::too_many_arguments)]
pub fn build_site(
    rule: &str,
    call: &str,
    path: String,
    line: u32,
    column: u32,
    end_line: u32,
    end_column: u32,
) -> LogSite {
    let api = leading_ident(call).unwrap_or(rule).to_string();
    let inner = as_call(call).map(|(_, inner)| inner).unwrap_or_default();
    let args = split_top_level_args(&inner);

    let mut level: Option<String> = None;
    let mut message = Message::default();
    let mut details = Vec::new();
    let mut hints = Vec::new();
    let mut contexts = Vec::new();
    let mut sqlstates = Vec::new();
    let mut part = "primary".to_string();
    let kind;

    match rule {
        "postgres-ereport" | "postgres-ereport-domain" => {
            kind = Kind::Backend;
            // ereport(LEVEL, ...); ereport_domain(LEVEL, DOMAIN, ...).
            if let Some(l) = args.first() {
                level = Some(l.trim().to_string());
            }
            let body_from = if rule == "postgres-ereport-domain" {
                2
            } else {
                1
            };
            // Rejoin the remaining args so we can scan for errXXX calls across
            // both the `(errmsg(...), ...)` grouped form and the flat form.
            let body = join_args_from(&inner, body_from);

            if let Some((_, a)) = find_calls(&body, ERRMSG_NAMES).into_iter().next() {
                message = message_from_expr(&first_arg(&a));
            }
            for (_, a) in find_calls(&body, ERRDETAIL_NAMES) {
                details.push(message_from_expr(&first_arg(&a)));
            }
            for (_, a) in find_calls(&body, ERRHINT_NAMES) {
                hints.push(message_from_expr(&first_arg(&a)));
            }
            for (_, a) in find_calls(&body, ERRCONTEXT_NAMES) {
                contexts.push(message_from_expr(&first_arg(&a)));
            }
            for (_, a) in find_calls(&body, ERRCODE_NAMES) {
                let code = first_arg(&a).trim().to_string();
                if !code.is_empty() {
                    sqlstates.push(code);
                }
            }
        }
        "postgres-elog" => {
            kind = Kind::Backend;
            if let Some(l) = args.first() {
                level = Some(l.trim().to_string());
            }
            if let Some(fmt) = args.get(1) {
                message = message_from_expr(fmt);
            }
        }
        "postgres-write-stderr" => {
            kind = Kind::Stderr;
            if let Some(fmt) = args.first() {
                message = message_from_expr(fmt);
            }
        }
        "postgres-pg-log-generic" => {
            kind = Kind::Frontend;
            part = "generic".to_string();
            if let Some(l) = args.first() {
                level = Some(l.trim().to_string());
            }
            if let Some(fmt) = args.get(2) {
                message = message_from_expr(fmt);
            }
        }
        // postgres-pg-log-primary / postgres-pg-log-aux and any other frontend
        // helper: message is the first argument, level & part come from the name.
        _ => {
            kind = Kind::Frontend;
            level = frontend_level(&api).map(str::to_string);
            part = frontend_part(&api).to_string();
            if let Some(fmt) = args.first() {
                message = message_from_expr(fmt);
            }
        }
    }

    LogSite {
        api,
        kind,
        level,
        message,
        details,
        hints,
        contexts,
        sqlstates,
        part: Some(part),
        path,
        line,
        column: Some(column),
        end_line: Some(end_line),
        end_column: Some(end_column),
        call: Some(call.to_string()),
        semgrep_rule: Some(rule.to_string()),
    }
}

/// Rejoin the argument list of `inner` starting at index `from`, back into a
/// single string we can scan for nested `errXXX` calls.
fn join_args_from(inner: &str, from: usize) -> String {
    let args = split_top_level_args(inner);
    args.into_iter().skip(from).collect::<Vec<_>>().join(", ")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn splits_top_level_args_respecting_nesting() {
        let a = split_top_level_args(r#"ERROR, foo(a, b), "x, y", bar"#);
        assert_eq!(a, vec!["ERROR", "foo(a, b)", "\"x, y\"", "bar"]);
    }

    #[test]
    fn committed_sample_roundtrips_through_core_index() {
        // The checked-in catalog sample must always parse via the contract type.
        let path = concat!(
            env!("CARGO_MANIFEST_DIR"),
            "/../../snippets/pg-catalog-sample.jsonl"
        );
        let raw = std::fs::read_to_string(path).expect("read pg-catalog-sample.jsonl");
        let idx = logref_core::Index::from_jsonl(&raw).expect("parse sample");
        assert!(idx.len() >= 40, "sample should be a representative set");
        // Every record carries the required provenance + an api.
        for s in &idx.sites {
            assert!(!s.api.is_empty());
            assert!(!s.path.is_empty());
            assert!(s.line > 0);
        }
    }

    #[test]
    fn decodes_escaped_quotes_and_newlines() {
        assert_eq!(decode_c_string(r#"a\"b\n"#), "a\"b\n");
        assert_eq!(decode_c_string(r#"tab\there"#), "tab\there");
    }

    #[test]
    fn literal_text_concatenates_adjacent_literals() {
        assert_eq!(
            literal_text(r#""could not open " "the file""#).as_deref(),
            Some("could not open the file")
        );
    }

    #[test]
    fn literal_text_peels_gettext_and_underscore() {
        assert_eq!(
            literal_text(r#"_("hello %s")"#).as_deref(),
            Some("hello %s")
        );
        assert_eq!(literal_text(r#"gettext("bye")"#).as_deref(), Some("bye"));
    }

    #[test]
    fn literal_text_is_none_for_computed_expressions() {
        assert_eq!(literal_text("msgbuf"), None);
        assert_eq!(literal_text(r#"psprintf("%s", x)"#), None);
        // A leading literal followed by non-literal is not a pure literal.
        assert_eq!(literal_text(r#""x" y"#), None);
    }

    #[test]
    fn find_calls_is_exact_and_string_aware() {
        // errdetail must not match errdetail_relkind_not_supported; errmsg must
        // not match errmsg_internal; a name inside a string is ignored.
        let body = r#"errcode(ERRCODE_X), errmsg("has errdetail( inside"), errdetail_relkind_not_supported(rk), errmsg_internal("y")"#;
        let msgs = find_calls(body, ERRMSG_NAMES);
        assert_eq!(msgs.len(), 2);
        assert_eq!(msgs[0].0, "errmsg");
        assert_eq!(msgs[1].0, "errmsg_internal");
        let details = find_calls(body, ERRDETAIL_NAMES);
        assert!(details.is_empty(), "errdetail_relkind_* is not errdetail");
    }

    #[test]
    fn ereport_grouped_form() {
        let call = "ereport(ERROR,\n\t\t(errcode(ERRCODE_UNDEFINED_TABLE),\n\t\t errmsg(\"could not open parent table of index \\\"%s\\\"\",\n\t\t\tRelationGetRelationName(indrel))))";
        let s = build_site("postgres-ereport", call, "f.c".into(), 1, 2, 4, 5);
        assert_eq!(s.api, "ereport");
        assert_eq!(s.kind, Kind::Backend);
        assert_eq!(s.level.as_deref(), Some("ERROR"));
        assert_eq!(
            s.message.text.as_deref(),
            Some("could not open parent table of index \"%s\"")
        );
        assert_eq!(s.sqlstates, vec!["ERRCODE_UNDEFINED_TABLE"]);
        assert_eq!(s.part.as_deref(), Some("primary"));
    }

    #[test]
    fn ereport_flat_form_with_detail_and_hint() {
        let call = r#"ereport(WARNING,
			errcode(ERRCODE_DUPLICATE_OBJECT),
			errmsg("skipping \"%s\"", name),
			errdetail("it already exists"),
			errhint("drop it first"))"#;
        let s = build_site("postgres-ereport", call, "f.c".into(), 10, 3, 14, 9);
        assert_eq!(s.level.as_deref(), Some("WARNING"));
        assert_eq!(s.message.text.as_deref(), Some("skipping \"%s\""));
        assert_eq!(s.details[0].text.as_deref(), Some("it already exists"));
        assert_eq!(s.hints[0].text.as_deref(), Some("drop it first"));
        assert_eq!(s.sqlstates, vec!["ERRCODE_DUPLICATE_OBJECT"]);
    }

    #[test]
    fn elog_takes_second_arg_as_format() {
        let s = build_site(
            "postgres-elog",
            r#"elog(DEBUG1, "page blk: %u, type leaf", blk)"#,
            "f.c".into(),
            1,
            1,
            1,
            1,
        );
        assert_eq!(s.api, "elog");
        assert_eq!(s.level.as_deref(), Some("DEBUG1"));
        assert_eq!(s.message.text.as_deref(), Some("page blk: %u, type leaf"));
        assert!(s.sqlstates.is_empty());
    }

    #[test]
    fn frontend_pg_log_error_maps_level() {
        let s = build_site(
            "postgres-pg-log-primary",
            r#"pg_log_error("connection to database failed: %s", msg)"#,
            "f.c".into(),
            1,
            1,
            1,
            1,
        );
        assert_eq!(s.api, "pg_log_error");
        assert_eq!(s.kind, Kind::Frontend);
        assert_eq!(s.level.as_deref(), Some("ERROR"));
        assert_eq!(
            s.message.text.as_deref(),
            Some("connection to database failed: %s")
        );
    }

    #[test]
    fn frontend_pg_fatal_and_detail_variants() {
        let f = build_site(
            "postgres-pg-log-primary",
            r#"pg_fatal("out of memory")"#,
            "f.c".into(),
            1,
            1,
            1,
            1,
        );
        assert_eq!(f.level.as_deref(), Some("FATAL"));
        assert_eq!(f.part.as_deref(), Some("primary"));

        let d = build_site(
            "postgres-pg-log-aux",
            r#"pg_log_error_detail("see the server log")"#,
            "f.c".into(),
            1,
            1,
            1,
            1,
        );
        assert_eq!(d.level.as_deref(), Some("ERROR"));
        assert_eq!(d.part.as_deref(), Some("detail"));
    }

    #[test]
    fn write_stderr_has_no_level() {
        let s = build_site(
            "postgres-write-stderr",
            r#"write_stderr("could not fork: %m")"#,
            "f.c".into(),
            1,
            1,
            1,
            1,
        );
        assert_eq!(s.api, "write_stderr");
        assert_eq!(s.kind, Kind::Stderr);
        assert_eq!(s.level, None);
        assert_eq!(s.message.text.as_deref(), Some("could not fork: %m"));
    }

    #[test]
    fn computed_message_keeps_expr_drops_text() {
        let s = build_site(
            "postgres-elog",
            r#"elog(ERROR, msgbuf)"#,
            "f.c".into(),
            1,
            1,
            1,
            1,
        );
        assert_eq!(s.message.expr.as_deref(), Some("msgbuf"));
        assert_eq!(s.message.text, None);
    }

    #[test]
    fn output_roundtrips_through_core_index() {
        let s = build_site(
            "postgres-ereport",
            r#"ereport(ERROR, (errcode(ERRCODE_X), errmsg("boom")))"#,
            "postgres/x.c".into(),
            5,
            2,
            5,
            40,
        );
        let line = serde_json::to_string(&s).unwrap();
        let idx = logref_core::Index::from_jsonl(&line).unwrap();
        assert_eq!(idx.len(), 1);
        assert_eq!(idx.sites[0].message.text.as_deref(), Some("boom"));
        assert_eq!(idx.sites[0], s);
    }

    /// End-to-end: run the real Semgrep binary over a Postgres checkout and
    /// parse the results. Ignored by default (needs `semgrep` + a checkout);
    /// run with `LOGREF_PG_CHECKOUT=/path/to/postgres cargo test -- --ignored`.
    #[test]
    #[ignore = "requires semgrep + a Postgres checkout via LOGREF_PG_CHECKOUT"]
    fn end_to_end_over_real_checkout() {
        let checkout = std::env::var("LOGREF_PG_CHECKOUT")
            .expect("set LOGREF_PG_CHECKOUT to a Postgres source dir");
        let rules = concat!(
            env!("CARGO_MANIFEST_DIR"),
            "/../../snippets/semgrep-rules.yml"
        );
        let json =
            std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../target/e2e-semgrep.json");
        let status = std::process::Command::new("semgrep")
            .args(["--config", rules, "--json", "--quiet", "--no-git-ignore"])
            .arg("--output")
            .arg(&json)
            .arg(&checkout)
            .status()
            .expect("spawn semgrep");
        assert!(status.success(), "semgrep failed");
        let raw = std::fs::read_to_string(&json).unwrap();
        let matches = parse_semgrep_json(&raw, |p| Ok(std::fs::read(p)?)).unwrap();
        assert!(matches.len() > 1000, "expected thousands of sites");
        let sites: Vec<_> = matches
            .iter()
            .map(|m| {
                build_site(
                    &m.rule,
                    &m.call,
                    m.path.clone(),
                    m.start_line,
                    m.start_col,
                    m.end_line,
                    m.end_col,
                )
            })
            .collect();
        assert!(sites.iter().any(|s| s.api == "ereport"));
        assert!(sites.iter().any(|s| s.message.text.is_some()));
    }
}
