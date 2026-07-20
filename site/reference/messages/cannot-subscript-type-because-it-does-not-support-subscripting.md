---
message: "cannot subscript type %s because it does not support subscripting"
slug: cannot-subscript-type-because-it-does-not-support-subscripting
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/executor/execExpr.c:3255"
  - "postgres/src/backend/parser/parse_node.c:270"
  - "postgres/src/backend/parser/parse_node.c:320"
reproduced: false
---

# `cannot subscript type %s because it does not support subscripting`

## What it means

A subscript expression (`value[...]`) was applied to a type that has no subscripting support. The placeholder names the type. Subscripting works for array types and a few types that register a subscript handler (like `jsonb`); other types cannot be indexed with `[]`.

## When it happens

Writing `x[1]` where `x` is a scalar or a type without a subscript handler, often after a value turned out to be a different type than expected, or a mistaken attempt to index a non-array.

## How to fix

Only subscript types that support it — arrays, `jsonb`, and types with a custom subscripting handler. If the value should be an array, ensure it actually is one (or cast it). For JSON, use the `jsonb`/`json` accessors or `jsonb` subscripting. Otherwise use the function appropriate to the type instead of `[]`.

## Example

*Illustrative* — subscripting a non-subscriptable type.

```sql
SELECT (42)[1];  -- cannot subscript type integer ...
```

## Related

- [cannot alter array type](./cannot-alter-array-type.md)
- [array subscript out of range](./array-subscript-out-of-range.md)
