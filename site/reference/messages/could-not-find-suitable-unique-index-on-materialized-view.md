---
message: "could not find suitable unique index on materialized view \"%s\""
slug: could-not-find-suitable-unique-index-on-materialized-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/matview.c:824"
reproduced: false
---

# `could not find suitable unique index on materialized view "%s"`

## What it means

`REFRESH MATERIALIZED VIEW CONCURRENTLY` needs a unique index on the view to compute the row-by-row difference, and no suitable one exists. A concurrent refresh updates the view in place, which requires a stable key for each row.

## When it happens

It happens when you run `REFRESH MATERIALIZED VIEW CONCURRENTLY` on a view that has no unique index, or whose only unique index covers an expression or partial predicate the refresh cannot use.

## How to fix

Create a unique index on one or more non-nullable columns that identify each row, then rerun the concurrent refresh. If no such key exists, refresh without `CONCURRENTLY`, which rebuilds the view wholesale and takes an exclusive lock instead.

## Example

*Illustrative* — a concurrent refresh with no unique index available.

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY sales_summary;
-- ERROR:  could not find suitable unique index on materialized view "sales_summary"
```

## Related

- [could not identify column in record data type](./could-not-identify-column-in-record-data-type.md)
- [could not find tuple for statistics object](./could-not-find-tuple-for-statistics-object.md)
