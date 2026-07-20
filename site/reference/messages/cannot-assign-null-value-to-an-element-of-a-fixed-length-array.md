---
message: "cannot assign null value to an element of a fixed-length array"
slug: cannot-assign-null-value-to-an-element-of-a-fixed-length-array
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2258"
reproduced: false
---

# `cannot assign null value to an element of a fixed-length array`

## What it means

An assignment tried to place a null into one element of a fixed-length array type. Fixed-length array types, such as `point` internally or certain composite layouts, have no per-element null bitmap, so an individual element cannot be null.

## When it happens

It occurs when updating a single element of a fixed-length array-backed value to `NULL`, for example through array subscript assignment.

## How to fix

Assign a non-null value to the element, or replace the whole value at once. If you need per-element nulls, use a variable-length array type rather than a fixed-length one.

## Example

*Illustrative* — a null into a fixed-length array element.

```text
ERROR:  cannot assign null value to an element of a fixed-length array
```

## Related

- [cannot assign to field of column because its type is not a composite type](./cannot-assign-to-field-of-column-because-its-type-is-not-a-composite-type.md)
- [cannot coerce to int](./cannot-coerce-to-int.md)
