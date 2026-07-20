---
message: "Did not find any tables named \"%s\"."
slug: did-not-find-any-tables-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4254"
reproduced: false
---

# `Did not find any tables named "%s".`

## What it means

A psql `\dt` command with a name pattern matched no table. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dt pattern` finds no table whose name matches, because none exists or the pattern does not match the search path.

## How to fix

List all tables with a bare `\dt`, check the pattern and search path, and schema-qualify (`\dt schema.name`) if the table lives elsewhere.

## Example

*Illustrative* — a pattern matching no table.

```text
\dt orders_*
-- Did not find any tables named "orders_*".
```

## Related

- [Did not find any tables](./did-not-find-any-tables.md)
- [Did not find any relations named](./did-not-find-any-relations-named.md)
