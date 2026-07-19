---
message: "cannot insert into column \"%s\" of view \"%s\""
slug: cannot-insert-into-column-of-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:3453"
reproduced: false
---

# `cannot insert into column "%s" of view "%s"`

## What it means

An `INSERT` targeted a view column that is not insertable. The column maps to something the view cannot write — a computed expression, a column with no underlying base column, or a non-updatable part of the view. The placeholders are the column and view names.

## When it happens

It occurs when you insert into an auto-updatable view but name a column whose definition is an expression or is otherwise not writable through the view.

## How to fix

Insert only into columns that map directly to base-table columns, or add an `INSTEAD OF INSERT` trigger to the view to define how writes to that column should be applied. Insert into the base table where possible.

## Example

*Illustrative* — insert into a computed view column.

```text
ERROR:  cannot insert into column "full_name" of view "v_people"
```

## Related

- [cannot insert into foreign table](./cannot-insert-into-foreign-table.md)
- [cannot merge into column of view](./cannot-merge-into-column-of-view.md)
