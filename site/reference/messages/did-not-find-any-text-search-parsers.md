---
message: "Did not find any text search parsers."
slug: did-not-find-any-text-search-parsers
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:5478"
reproduced: false
---

# `Did not find any text search parsers.`

## What it means

A psql `\dFp` command found no text-search parsers to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dFp` runs where no text-search parsers are visible on the search path.

## How to fix

Nothing is wrong. The built-in parser lives in `pg_catalog`; use `\dFpS` to include system objects.

## Example

*Illustrative* — no parsers to show.

```text
\dFp
-- Did not find any text search parsers.
```

## Related

- [Did not find any text search parser named](./did-not-find-any-text-search-parser-named.md)
- [Did not find any text search configurations](./did-not-find-any-text-search-configurations.md)
