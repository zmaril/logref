---
message: "cannot insert into view \"%s\""
slug: cannot-insert-into-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:3222"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3257"
reproduced: false
---

# `cannot insert into view "%s"`

## What it means

An `INSERT` targeted a view that is not automatically updatable and has no rule or trigger to make it insertable. The placeholder is the view name. Postgres cannot translate the insert into an action on the underlying tables.

## When it happens

Running `INSERT INTO some_view` where the view joins tables, aggregates, uses `DISTINCT`/`GROUP BY`, or otherwise is not a simple updatable view, and no `INSTEAD OF INSERT` trigger or `DO INSTEAD` rule exists.

## How to fix

Insert into the base table directly, or make the view insertable with an `INSTEAD OF INSERT` trigger (or a `DO INSTEAD` rule). The error `DETAIL` usually explains why the view is not auto-updatable.

## Example

*Illustrative* — inserting into a non-updatable view.

```sql
INSERT INTO order_summary VALUES (1, 2);
-- ERROR:  cannot insert into view "order_summary"
```

## Related

- [cannot delete from view](./cannot-delete-from-view.md)
- [cannot update view](./cannot-update-view.md)
