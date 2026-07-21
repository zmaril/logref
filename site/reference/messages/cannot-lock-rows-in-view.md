---
message: "cannot lock rows in view \"%s\""
slug: cannot-lock-rows-in-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1252"
reproduced: false
---

# `cannot lock rows in view "%s"`

## What it means

A row-locking clause was applied to a query over a view. A view has no rows of its own to lock, so `FOR UPDATE`/`FOR SHARE` cannot act on it directly. The placeholder is the view name.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` reads from a view rather than from a base table.

## How to fix

Apply the row-locking clause to the underlying base tables — for a simple view you can query the base table with the lock, or use an updatable view with the lock pushed to its source relations.

## Example

*Illustrative* — FOR UPDATE on a view.

```text
ERROR:  cannot lock rows in view "v_orders"
```

## Related

- [cannot lock rows in materialized view](./cannot-lock-rows-in-materialized-view.md)
- [cannot lock rows in relation](./cannot-lock-rows-in-relation.md)
