---
message: "cannot extract elements from a scalar"
slug: cannot-extract-elements-from-a-scalar
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:2233"
reproduced: false
---

# `cannot extract elements from a scalar`

## What it means

A JSON function that iterates over array elements was applied to a JSON scalar. Scalars — numbers, strings, booleans, and null — have no elements to extract, so the request is rejected.

## When it happens

It occurs when a function such as `jsonb_array_elements()` or `json_array_elements()` is given a JSON value that is a scalar rather than an array.

## How to fix

Check the JSON structure before extracting: use `jsonb_typeof()` to confirm the value is an array, or filter to rows whose JSON is an array. Feed array-element functions only array values.

## Example

*Illustrative* — array extraction over a scalar.

```text
ERROR:  cannot extract elements from a scalar
```

## Related

- [cannot extract elements from an object](./cannot-extract-elements-from-an-object.md)
- [cannot merge incompatible arrays](./cannot-merge-incompatible-arrays.md)
