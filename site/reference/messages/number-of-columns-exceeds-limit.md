---
message: "number of columns (%d) exceeds limit (%d)"
slug: number-of-columns-exceeds-limit
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_COLUMNS
    code: "54011"
call_sites:
  - "postgres/src/backend/access/common/heaptuple.c:1039"
  - "postgres/src/backend/access/common/heaptuple.c:1407"
reproduced: false
---

# `number of columns (%d) exceeds limit (%d)`

## What it means

A relation or result was defined with more columns than Postgres allows. The placeholders show the requested count and the limit (columns per table cap at 1600, and often lower after accounting for dropped columns).

## When it happens

It arises from `CREATE TABLE`, `ALTER TABLE ... ADD COLUMN`, or wide function/`SELECT` outputs when the column count crosses the limit. Repeated add/drop cycles can also hit it because dropped columns still count physically.

## How to fix

Reduce the number of columns: split the table into related tables, or group values into composite/jsonb columns. If churn from many dropped columns caused it, rewrite the table (for example `VACUUM FULL` or a recreate) to reclaim the physical column slots.

## Example

*Illustrative* — a table with too many columns.

```text
ERROR:  number of columns (1700) exceeds limit (1600)
```

## Related

- [index row requires bytes maximum size is](./index-row-requires-bytes-maximum-size-is.md)
- [length for type cannot exceed](./length-for-type-cannot-exceed.md)
