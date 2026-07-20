---
message: "Did not find any text search configurations."
slug: did-not-find-any-text-search-configurations
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:5863"
reproduced: false
---

# `Did not find any text search configurations.`

## What it means

A psql `\dF` command found no text-search configurations to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dF` runs where no text-search configurations are visible on the search path.

## How to fix

Nothing is wrong. Standard configurations live in `pg_catalog`; use `\dFS` to include system objects, and check the search path.

## Example

*Illustrative* — no configurations to show.

```text
\dF
-- Did not find any text search configurations.
```

## Related

- [Did not find any text search configuration named](./did-not-find-any-text-search-configuration-named.md)
- [Did not find any text search parsers](./did-not-find-any-text-search-parsers.md)
