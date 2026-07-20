---
message: "cannot call %s on an object"
slug: cannot-call-on-an-object
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4223"
reproduced: false
---

# `cannot call %s on an object`

## What it means

A JSON function that operates on array elements — such as one that iterates or expands an array — was given a JSON object instead. The first placeholder is the function name. Array-oriented JSON accessors require an array as input.

## When it happens

It occurs when a function like `jsonb_array_elements` receives a JSON object rather than an array.

## How to fix

Pass a JSON array to the function, or check the value's type with `jsonb_typeof` before calling. Use object accessors for objects and array accessors for arrays.

## Example

*Illustrative* — an array function on an object.

```text
ERROR:  cannot call jsonb_array_elements on an object
```

## Related

- [cannot call on a non-object](./cannot-call-on-a-non-object.md)
- [cannot coerce to boolean](./cannot-coerce-to-boolean.md)
