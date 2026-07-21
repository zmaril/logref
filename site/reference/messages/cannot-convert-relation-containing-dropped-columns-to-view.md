---
message: "cannot convert relation containing dropped columns to view"
slug: cannot-convert-relation-containing-dropped-columns-to-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteDefine.c:554"
reproduced: false
---

# `cannot convert relation containing dropped columns to view`

## What it means

A `CREATE OR REPLACE VIEW` (or a conversion path) tried to turn a table into a view, but the table still has dropped columns recorded in its layout. Dropped columns leave placeholder attributes that a view cannot reproduce, so the conversion is refused.

## When it happens

It occurs when converting a relation into a view where the relation has had columns dropped, leaving `pg_attribute` entries marked dropped.

## How to fix

Create the view as a fresh object over the relation instead of converting the relation in place, or rebuild the table without the dropped-column placeholders (for example by recreating it) before converting.

## Example

*Illustrative* — converting a relation with dropped columns.

```text
ERROR:  cannot convert relation containing dropped columns to view
```

## Related

- [cannot drop column from typed table](./cannot-drop-column-from-typed-table.md)
- [cannot change data type of view column from to](./cannot-change-data-type-of-view-column-from-to.md)
