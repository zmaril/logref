---
message: "Did not find any foreign tables."
slug: did-not-find-any-foreign-tables
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4293"
reproduced: false
---

# `Did not find any foreign tables.`

## What it means

A psql `\det` command found no foreign tables to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\det` runs on a database (or search path) with no foreign tables defined.

## How to fix

Nothing is wrong. If you expected foreign tables, confirm the schema and search path, and check that the foreign server and tables were created (`CREATE FOREIGN TABLE`).

## Example

*Illustrative* — no foreign tables to show.

```text
\det
-- Did not find any foreign tables.
```

## Related

- [Did not find any foreign tables named](./did-not-find-any-foreign-tables-named.md)
- [Did not find any tables](./did-not-find-any-tables.md)
