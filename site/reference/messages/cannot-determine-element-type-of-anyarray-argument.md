---
message: "cannot determine element type of \"anyarray\" argument"
slug: cannot-determine-element-type-of-anyarray-argument
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2386"
reproduced: false
---

# `cannot determine element type of "anyarray" argument`

## What it means

A polymorphic function declared with an `anyarray` argument was called in a way that leaves the array's element type unknown. Postgres resolves `anyarray` from the actual argument, and here it could not, so the element type is undetermined.

## When it happens

It occurs when a polymorphic function receives a value — often an untyped `NULL` or empty construct — that does not pin down the array element type.

## How to fix

Give the argument a definite array type with an explicit cast, such as `NULL::int[]`, so the element type can be resolved. Ensure polymorphic calls carry enough type information.

## Example

*Illustrative* — an unresolved anyarray.

```text
ERROR:  cannot determine element type of "anyarray" argument
```

## Related

- [cannot determine type of empty array](./cannot-determine-type-of-empty-array.md)
- [cannot coerce to int](./cannot-coerce-to-int.md)
