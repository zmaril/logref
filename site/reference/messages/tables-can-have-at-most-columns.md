---
message: "tables can have at most %d columns"
slug: tables-can-have-at-most-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_COLUMNS
    code: "54011"
call_sites:
  - "postgres/src/backend/catalog/heap.c:462"
  - "postgres/src/backend/commands/tablecmds.c:2638"
  - "postgres/src/backend/commands/tablecmds.c:3101"
  - "postgres/src/backend/commands/tablecmds.c:7510"
reproduced: false
---

# `tables can have at most %d columns`

## What it means

A table definition exceeded the maximum number of columns Postgres allows. The placeholder is the limit (1600, minus overhead in some cases). The column count is a hard architectural limit tied to the on-disk tuple format, not a tunable.

## When it happens

Creating a table with too many columns, adding columns to one already near the limit, or a `SELECT INTO`/`CREATE TABLE AS` whose result has too many output columns. Dropped columns still count toward the limit until the table is rewritten.

## How to fix

Reduce the column count: split the table into related tables joined by a key, or group columns into composite types, `jsonb`, or arrays where appropriate. If the table accumulated many dropped columns, a table rewrite (`VACUUM FULL` or a recreate) reclaims their slots. The 1600 ceiling itself cannot be raised.

## Example

*Illustrative* — a table definition past the column limit.

```text
ERROR:  tables can have at most 1600 columns
```

## Related

- [attribute number exceeds number of columns](./attribute-number-exceeds-number-of-columns.md)
- [column named in key does not exist](./column-named-in-key-does-not-exist.md)
