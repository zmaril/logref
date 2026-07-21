---
message: "cannot change collation of view column \"%s\" from \"%s\" to \"%s\""
slug: cannot-change-collation-of-view-column-from-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/view.c:315"
reproduced: false
---

# `cannot change collation of view column "%s" from "%s" to "%s"`

## What it means

A `CREATE OR REPLACE VIEW` changed the collation of an existing view column. A replacement view must keep each existing column's collation, since dependent objects rely on it. The placeholders are the column name and the old and new collations.

## When it happens

It occurs when replacing a view with a definition whose column resolves to a different collation than the original view had.

## How to fix

Keep the existing collation for that column in the replacement definition, applying an explicit `COLLATE` if needed to match. To genuinely change a column's collation, drop and recreate the view rather than replacing it in place.

## Example

*Illustrative* — a changed view-column collation.

```text
ERROR:  cannot change collation of view column "c" from "en_US" to "C"
```

## Related

- [cannot change data type of view column from to](./cannot-change-data-type-of-view-column-from-to.md)
- [cannot change name of view column to](./cannot-change-name-of-view-column-to.md)
