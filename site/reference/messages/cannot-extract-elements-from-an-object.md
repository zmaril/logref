---
message: "cannot extract elements from an object"
slug: cannot-extract-elements-from-an-object
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:2237"
reproduced: false
---

# `cannot extract elements from an object`

## What it means

A JSON function that iterates over array elements was applied to a JSON object. Objects hold key-value pairs, not positional elements, so array-element extraction does not apply.

## When it happens

It occurs when a function such as `jsonb_array_elements()` is given a JSON object. To iterate an object you need the key-value form instead.

## How to fix

Use an object-oriented function such as `jsonb_each()` or `jsonb_object_keys()` to iterate an object, and reserve `jsonb_array_elements()` for arrays. Confirm the shape with `jsonb_typeof()` first.

## Example

*Illustrative* — array extraction over an object.

```text
ERROR:  cannot extract elements from an object
```

## Related

- [cannot extract elements from a scalar](./cannot-extract-elements-from-a-scalar.md)
- [cannot merge incompatible arrays](./cannot-merge-incompatible-arrays.md)
