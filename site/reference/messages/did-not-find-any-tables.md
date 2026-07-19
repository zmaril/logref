---
message: "Did not find any tables."
slug: did-not-find-any-tables
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4283"
reproduced: false
---

# `Did not find any tables.`

## What it means

A psql `\dt` command found no tables to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dt` runs where no ordinary tables are visible on the search path.

## How to fix

Nothing is wrong. If you expected tables, check the schema and search path — `\dt *.*` lists across all schemas — and confirm you are on the right database.

## Example

*Illustrative* — no tables to show.

```text
\dt
-- Did not find any tables.
```

## Related

- [Did not find any tables named](./did-not-find-any-tables-named.md)
- [Did not find any relations](./did-not-find-any-relations-fc25da.md)
