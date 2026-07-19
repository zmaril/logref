---
message: "Did not find any text search configuration named \"%s\"."
slug: did-not-find-any-text-search-configuration-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:5860"
reproduced: false
---

# `Did not find any text search configuration named "%s".`

## What it means

A psql `\dF` command with a name pattern matched no text-search configuration. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dF pattern` finds no text-search configuration whose name matches.

## How to fix

List all configurations with a bare `\dF`, check the pattern and search path, and create one with `CREATE TEXT SEARCH CONFIGURATION` if needed.

## Example

*Illustrative* — a pattern matching no configuration.

```text
\dF myconf
-- Did not find any text search configuration named "myconf".
```

## Related

- [Did not find any text search configurations](./did-not-find-any-text-search-configurations.md)
- [Did not find any text search parser named](./did-not-find-any-text-search-parser-named.md)
