---
message: "cannot call %s on a non-object"
slug: cannot-call-on-a-non-object
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:1986"
reproduced: false
---

# `cannot call %s on a non-object`

## What it means

A JSON function that operates on object members — such as one that iterates keys or extracts fields — was given a JSON value that is not an object. The first placeholder is the function name. Object-oriented JSON accessors require an object as input.

## When it happens

It occurs when a function like `jsonb_each` or `jsonb_object_keys` receives a scalar, array, or null instead of a JSON object.

## How to fix

Pass a JSON object to the function, or guard the call with a type check using `jsonb_typeof`. Restructure the query so only object-typed values reach object accessors.

## Example

*Illustrative* — an object function on an array.

```text
ERROR:  cannot call jsonb_each on a non-object
```

## Related

- [cannot call on an object](./cannot-call-on-an-object.md)
- [cannot call function via fastpath interface](./cannot-call-function-via-fastpath-interface.md)
