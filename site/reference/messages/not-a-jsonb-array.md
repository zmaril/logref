---
message: "not a jsonb array"
slug: not-a-jsonb-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonb_util.c:479"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:1617"
reproduced: false
---

# `not a jsonb array`

## What it means

Internal error. Jsonb code that requires an array container was handed a value that is not a jsonb array. It is a consistency guard in jsonb array handling.

## When it happens

It fires from internal jsonb routines expecting an array when the value is an object or scalar. Ordinary SQL usually reports a clearer type error first; reaching this guard points to an internal path or an extension calling jsonb internals with the wrong value.

## How to fix

This is a can't-happen guard for normal SQL. If a custom C function calls jsonb array APIs, verify the value is an array first. Otherwise capture the query and report a reproducible case.

## Example

*Illustrative* — a non-array where a jsonb array is required.

```text
ERROR:  not a jsonb array
```

## Related

- [jsonb subscript does not support slices](./jsonb-subscript-does-not-support-slices.md)
- [jsonb scalar type mismatch](./jsonb-scalar-type-mismatch.md)
