---
message: "cannot change name of view column \"%s\" to \"%s\""
slug: cannot-change-name-of-view-column-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/view.c:287"
reproduced: false
---

# `cannot change name of view column "%s" to "%s"`

## What it means

A `CREATE OR REPLACE VIEW` renamed an existing view column. A replacement view must keep its existing columns in the same order with the same names, since dependents reference them by name. The placeholders are the old and new column names.

## When it happens

It occurs when replacing a view with a definition whose output column names differ from the original view's columns.

## How to fix

Preserve existing column names in the replacement, using `AS` aliases to match. To rename a view column, use `ALTER TABLE ... RENAME COLUMN` on the view, or drop and recreate it.

## Example

*Illustrative* — renaming a view column.

```text
ERROR:  cannot change name of view column "a" to "b"
```

## Related

- [cannot change data type of view column from to](./cannot-change-data-type-of-view-column-from-to.md)
- [cannot change collation of view column from to](./cannot-change-collation-of-view-column-from-to.md)
