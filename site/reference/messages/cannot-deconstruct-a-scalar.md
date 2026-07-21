---
message: "cannot deconstruct a scalar"
slug: cannot-deconstruct-a-scalar
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:2188"
reproduced: false
---

# `cannot deconstruct a scalar`

## What it means

A jsonpath or SQL/JSON operation that walks into a structured value was applied to a scalar. Scalars have no members to descend into, so the requested step cannot be taken.

## When it happens

It occurs in SQL/JSON path evaluation when an accessor expects an object or array but the current item is a scalar such as a number or string.

## How to fix

Apply structural accessors only to objects or arrays, guarding with a type check where the shape varies. Adjust the path so scalar items are handled without descending into them.

## Example

*Illustrative* — descending into a scalar.

```text
ERROR:  cannot deconstruct a scalar
```

## Related

- [cannot deconstruct an array as an object](./cannot-deconstruct-an-array-as-an-object.md)
- [cannot delete path in scalar](./cannot-delete-path-in-scalar.md)
