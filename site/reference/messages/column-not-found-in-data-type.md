---
message: "column \"%s\" not found in data type %s"
slug: column-not-found-in-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:417"
reproduced: false
---

# `column "%s" not found in data type %s`

## What it means

A field reference used dot notation to pull a named field out of a composite value, but the composite type has no field with that name. The field access cannot be resolved.

## When it happens

It happens when an expression like `(rowval).fieldname` or `tab.col.field` names a field that the composite type does not define.

## How to fix

Use a field name that exists in the composite type, or check the type's definition. Watch for typos and for cases where the left side is not the composite you think it is.

## Example

*Illustrative* — a missing field on a composite value.

```sql
SELECT (ROW(1,2)::point).z;
-- ERROR:  column "z" not found in data type point
```

## Related

- [column notation applied to a non-composite type](./column-notation-applied-to-type-which-is-not-a-composite-type.md)
- [column name/value list contains nonexistent column name](./column-name-value-list-contains-nonexistent-column-name.md)
