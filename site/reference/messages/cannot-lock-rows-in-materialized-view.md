---
message: "cannot lock rows in materialized view \"%s\""
slug: cannot-lock-rows-in-materialized-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1260"
reproduced: false
---

# `cannot lock rows in materialized view "%s"`

## What it means

A row-locking clause such as `FOR UPDATE` or `FOR SHARE` was applied to a query over a materialized view. Materialized-view rows are a stored snapshot, not live base-table rows, so they cannot be row-locked. The placeholder is the view name.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` reads from a materialized view.

## How to fix

Remove the row-locking clause from queries over the materialized view, or lock the underlying base tables directly if you need to serialize updates to the source data.

## Example

*Illustrative* — FOR UPDATE on a materialized view.

```text
ERROR:  cannot lock rows in materialized view "mv_sales"
```

## Related

- [cannot lock rows in view](./cannot-lock-rows-in-view.md)
- [cannot lock rows in sequence](./cannot-lock-rows-in-sequence.md)
