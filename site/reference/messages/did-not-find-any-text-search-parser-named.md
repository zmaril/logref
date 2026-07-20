---
message: "Did not find any text search parser named \"%s\"."
slug: did-not-find-any-text-search-parser-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:5475"
reproduced: false
---

# `Did not find any text search parser named "%s".`

## What it means

A psql `\dFp` command with a name pattern matched no text-search parser. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dFp pattern` finds no text-search parser whose name matches.

## How to fix

List all parsers with a bare `\dFp`, and use `\dFpS` to include the built-in `default` parser in `pg_catalog`.

## Example

*Illustrative* — a pattern matching no parser.

```text
\dFp myparser
-- Did not find any text search parser named "myparser".
```

## Related

- [Did not find any text search parsers](./did-not-find-any-text-search-parsers.md)
- [Did not find any text search configuration named](./did-not-find-any-text-search-configuration-named.md)
