---
message: "cannot deconstruct an array as an object"
slug: cannot-deconstruct-an-array-as-an-object
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:2174"
reproduced: false
---

# `cannot deconstruct an array as an object`

## What it means

A jsonpath or SQL/JSON operation used an object accessor on an array. Arrays are indexed by position, not by key, so treating one as an object with named members is invalid.

## When it happens

It occurs in SQL/JSON path evaluation when a key or member accessor is applied to an array value.

## How to fix

Use array accessors — index or wildcard — on arrays, and object accessors on objects. Correct the path so each accessor matches the value's shape.

## Example

*Illustrative* — an object accessor on an array.

```text
ERROR:  cannot deconstruct an array as an object
```

## Related

- [cannot deconstruct a scalar](./cannot-deconstruct-a-scalar.md)
- [cannot delete from object using integer index](./cannot-delete-from-object-using-integer-index.md)
