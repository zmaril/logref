---
message: "cannot refresh materialized view \"%s\" concurrently"
slug: cannot-refresh-materialized-view-concurrently
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/matview.c:270"
reproduced: false
---

# `cannot refresh materialized view "%s" concurrently`

## What it means

A `REFRESH MATERIALIZED VIEW CONCURRENTLY` was rejected because the view does not meet the requirements for a concurrent refresh. A concurrent refresh needs a unique index that covers all rows, and the view lacks one. The placeholder is the view name.

## When it happens

It occurs when you run `REFRESH MATERIALIZED VIEW CONCURRENTLY` on a materialized view that has no suitable unique index, or that has never been populated.

## How to fix

Create a unique index on the materialized view over columns that uniquely identify every row, then retry the concurrent refresh. For the first population, run a plain `REFRESH MATERIALIZED VIEW` without `CONCURRENTLY`.

## Example

*Illustrative* — concurrent refresh with no unique index.

```text
ERROR:  cannot refresh materialized view "mv_sales" concurrently
```

## Related

- [cannot lock rows in materialized view](./cannot-lock-rows-in-materialized-view.md)
- [cannot refresh version of default collation](./cannot-refresh-version-of-default-collation.md)
