---
message: "column notation .%s applied to type %s, which is not a composite type"
slug: column-notation-applied-to-type-which-is-not-a-composite-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:429"
reproduced: false
---

# `column notation .%s applied to type %s, which is not a composite type`

## What it means

A `.field` access was applied to a value whose type is not composite. Dotted field notation only works on row/composite types, so it cannot extract a field from a scalar.

## When it happens

It happens when an expression treats a scalar value as if it were a row, for example `x.y` where `x` is an `integer` rather than a composite value.

## How to fix

Apply field notation only to composite values. If you meant a table column, qualify it correctly; if the left side should be a row, cast or construct it as the appropriate composite type first.

## Example

*Illustrative* — field notation on a scalar.

```sql
SELECT (1).x;
-- ERROR:  column notation .x applied to type integer, which is not a composite type
```

## Related

- [column not found in data type](./column-not-found-in-data-type.md)
- [column has pseudo-type](./column-has-pseudo-type.md)
