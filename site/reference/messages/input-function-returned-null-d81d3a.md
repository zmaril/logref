---
message: "input function %u returned NULL"
slug: input-function-returned-null-d81d3a
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/fmgr/fmgr.c:1561"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1624"
reproduced: false
---

# `input function %u returned NULL`

## What it means

Internal error. A type's text input function returned NULL for a non-NULL input, which the input contract forbids. The placeholder is the function OID.

## When it happens

It fires from the type-input machinery when converting a non-NULL text value to an internal datum and the input function unexpectedly returns NULL. Ordinary casts do not surface it; it points to a misbehaving custom type input function.

## How to fix

This is an internal contract check. If a custom or extension type is involved, fix its C input function so it never returns NULL for a non-NULL input (it should raise an error on bad input instead). For built-in types, capture the value and report a reproducible case.

## Example

*Illustrative* — an input function returning NULL for real input.

```text
ERROR:  input function 16401 returned NULL
```

## Related

- [input function returned non-NULL](./input-function-returned-non-null.md)
- [is not a base type](./is-not-a-base-type.md)
