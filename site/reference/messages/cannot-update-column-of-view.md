---
message: "cannot update column \"%s\" of view \"%s\""
slug: cannot-update-column-of-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:3461"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3508"
reproduced: false
---

# `cannot update column "%s" of view "%s"`

## What it means

An `UPDATE` set a view column that is not updatable, even though the view itself allows some updates. The placeholders are the column and the view. That particular column maps to an expression, literal, or computed value with no single base column behind it.

## When it happens

Updating a column of an otherwise-updatable view where the column is derived — an expression, a constant, or a function result — rather than a direct reference to a base-table column.

## How to fix

Update only the view columns that map directly to base-table columns, or update the base table for computed columns. To make a derived column updatable, add an `INSTEAD OF UPDATE` trigger that interprets the intended change.

## Example

*Illustrative* — updating a computed view column.

```sql
UPDATE v SET full_name = 'x';  -- full_name is first || ' ' || last
-- ERROR:  cannot update column "full_name" of view "v"
```

## Related

- [cannot update view](./cannot-update-view.md)
- [cannot drop columns from view](./cannot-drop-columns-from-view.md)
