---
message: "cannot update view \"%s\""
slug: cannot-update-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:3230"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3266"
reproduced: false
---

# `cannot update view "%s"`

## What it means

An `UPDATE` targeted a view that is not automatically updatable and has no rule or trigger to make it updatable. The placeholder is the view name. Postgres cannot translate the update into an action on the underlying tables.

## When it happens

Running `UPDATE some_view SET ...` where the view joins tables, aggregates, uses `DISTINCT`/`GROUP BY`, or otherwise is not a simple updatable view, and no `INSTEAD OF UPDATE` trigger or `DO INSTEAD` rule exists.

## How to fix

Update the base table directly, or make the view updatable with an `INSTEAD OF UPDATE` trigger (or a `DO INSTEAD` rule). The error `DETAIL` usually explains why the view is not auto-updatable.

## Example

*Illustrative* — updating a non-updatable view.

```sql
UPDATE order_summary SET total = 0;
-- ERROR:  cannot update view "order_summary"
```

## Related

- [cannot update column of view](./cannot-update-column-of-view.md)
- [cannot insert into view](./cannot-insert-into-view.md)
