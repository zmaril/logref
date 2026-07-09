//! Core model for LogRef.
//!
//! A database's log surface is finite and enumerable: every message it can
//! print comes from a specific call site in its source. This crate defines the
//! structured record for one such site — its message, severity, error code, and
//! `file:line` provenance — and an in-memory [`Index`] over a collection of
//! them. Extraction (turning source into records) and serving (search + pages)
//! are built on top of this model; see `notes/design.md`.

use serde::{Deserialize, Serialize};

/// Which logging surface a site belongs to. For Postgres: `ereport`/`elog` are
/// `Backend`, the `pg_log_*` frontend helpers are `Frontend`, and early-startup
/// `write_stderr` is `Stderr`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum Kind {
    Backend,
    Frontend,
    Stderr,
    Unknown,
}

/// A single message expression: the raw source text (`expr`) and, when it could
/// be decoded from string literals / `gettext` wrappers, the literal `text`.
#[derive(Debug, Clone, Default, PartialEq, Eq, Serialize, Deserialize)]
pub struct Message {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expr: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub text: Option<String>,
}

impl Message {
    /// The best human-readable form: the decoded literal if we have it,
    /// otherwise the raw expression.
    pub fn display(&self) -> Option<&str> {
        self.text.as_deref().or(self.expr.as_deref())
    }
}

/// One extracted log/error call site.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct LogSite {
    /// The logging API used, e.g. `ereport`, `elog`, `pg_log_error`.
    pub api: String,
    pub kind: Kind,
    /// Severity level as written at the call site, e.g. `ERROR`, `WARNING`.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub level: Option<String>,
    #[serde(default)]
    pub message: Message,
    /// Error-code identifiers (e.g. Postgres `SQLSTATE` macros).
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub sqlstates: Vec<String>,
    /// Source path relative to the checkout root.
    pub path: String,
    /// 1-based line number of the call.
    pub line: u32,
}

impl LogSite {
    /// The provenance handle, `path:line` — stable identity for a site.
    pub fn location(&self) -> String {
        format!("{}:{}", self.path, self.line)
    }
}

/// An in-memory collection of log sites with simple lookup.
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct Index {
    pub sites: Vec<LogSite>,
}

impl Index {
    pub fn new(sites: Vec<LogSite>) -> Self {
        Self { sites }
    }

    /// Parse an inventory in JSON Lines form (one [`LogSite`] object per line).
    /// Blank lines are ignored.
    pub fn from_jsonl(input: &str) -> serde_json::Result<Self> {
        let mut sites = Vec::new();
        for line in input.lines() {
            let line = line.trim();
            if line.is_empty() {
                continue;
            }
            sites.push(serde_json::from_str(line)?);
        }
        Ok(Self { sites })
    }

    pub fn len(&self) -> usize {
        self.sites.len()
    }

    pub fn is_empty(&self) -> bool {
        self.sites.is_empty()
    }

    /// Case-insensitive substring search over each site's message text. A
    /// placeholder for the real search engine served by the site; enough to
    /// exercise the model and back the `scan` CLI.
    pub fn search<'a>(&'a self, query: &str) -> Vec<&'a LogSite> {
        let needle = query.to_lowercase();
        self.sites
            .iter()
            .filter(|s| {
                s.message
                    .display()
                    .is_some_and(|m| m.to_lowercase().contains(&needle))
            })
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample() -> &'static str {
        r#"{"api":"ereport","kind":"backend","level":"ERROR","message":{"text":"could not open parent table of index \"%s\""},"sqlstates":["ERRCODE_UNDEFINED_TABLE"],"path":"postgres/contrib/amcheck/verify_common.c","line":127}
{"api":"elog","kind":"backend","level":"DEBUG1","message":{"text":"page blk: %u, type leaf"},"path":"postgres/contrib/amcheck/verify_gin.c","line":191}"#
    }

    #[test]
    fn parses_jsonl_inventory() {
        let index = Index::from_jsonl(sample()).unwrap();
        assert_eq!(index.len(), 2);
        assert!(!index.is_empty());
    }

    #[test]
    fn location_is_path_and_line() {
        let index = Index::from_jsonl(sample()).unwrap();
        assert_eq!(
            index.sites[0].location(),
            "postgres/contrib/amcheck/verify_common.c:127"
        );
    }

    #[test]
    fn search_matches_message_text_case_insensitively() {
        let index = Index::from_jsonl(sample()).unwrap();
        let hits = index.search("PARENT TABLE");
        assert_eq!(hits.len(), 1);
        assert_eq!(hits[0].sqlstates, vec!["ERRCODE_UNDEFINED_TABLE"]);
    }

    #[test]
    fn roundtrips_through_json() {
        let index = Index::from_jsonl(sample()).unwrap();
        let encoded = serde_json::to_string(&index.sites[0]).unwrap();
        let decoded: LogSite = serde_json::from_str(&encoded).unwrap();
        assert_eq!(index.sites[0], decoded);
    }
}
