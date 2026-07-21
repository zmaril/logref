---
message: "cannot delete from view \"%s\""
slug: cannot-delete-from-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:3238"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3275"
reproduced: false
---

# `cannot delete from view "%s"`

## What it means

A `DELETE` targeted a view that is not automatically updatable and has no rule or trigger to make it deletable. The placeholder is the view name. Postgres cannot translate the delete into an action on the underlying tables.

## When it happens

Running `DELETE FROM some_view` where the view joins multiple tables, aggregates, uses `DISTINCT`/`GROUP BY`, or otherwise falls outside the simple-view rules, and no `INSTEAD OF DELETE` trigger or `DO INSTEAD` rule is defined.

## How to fix

Delete from the underlying base table directly, or make the view deletable by adding an `INSTEAD OF DELETE` trigger (or a `DO INSTEAD` rule) that performs the deletion. The error `DETAIL` usually names why the view is not auto-updatable.

## Example

*Illustrative* — deleting from a non-updatable view.

```sql
DELETE FROM order_summary WHERE id = 1;
-- ERROR:  cannot delete from view "order_summary"
```

## Related

- [cannot insert into view](./cannot-insert-into-view.md)
- [cannot update view](./cannot-update-view.md)
