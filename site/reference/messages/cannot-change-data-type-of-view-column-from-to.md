---
message: "cannot change data type of view column \"%s\" from %s to %s"
slug: cannot-change-data-type-of-view-column-from-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/view.c:301"
reproduced: false
---

# `cannot change data type of view column "%s" from %s to %s`

## What it means

A `CREATE OR REPLACE VIEW` changed the data type of an existing view column. A replacement view must preserve each existing column's type, because dependent objects and clients rely on the view's fixed column layout. The placeholders are the column name and the old and new types.

## When it happens

It occurs when replacing a view with a definition whose column produces a different type than the original.

## How to fix

Keep the existing column types in the replacement, adding explicit casts if the underlying query changed. To change a column's type, drop and recreate the view instead of replacing it in place.

## Example

*Illustrative* — a changed view-column type.

```text
ERROR:  cannot change data type of view column "c" from integer to text
```

## Related

- [cannot change collation of view column from to](./cannot-change-collation-of-view-column-from-to.md)
- [cannot change name of view column to](./cannot-change-name-of-view-column-to.md)
