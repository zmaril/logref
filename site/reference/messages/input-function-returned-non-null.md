---
message: "input function %u returned non-NULL"
slug: input-function-returned-non-null
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/fmgr/fmgr.c:1555"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1618"
reproduced: false
---

# `input function %u returned non-NULL`

## What it means

Internal error. When a type's text input function is called on a NULL input under a mode that must yield NULL, the function returned a non-NULL datum instead, violating the input-function contract. The placeholder is the function OID.

## When it happens

It fires from the type-input machinery, notably where a NULL is passed to an input function that is expected to return NULL for it. Ordinary casts and inserts do not surface it; it points to a misbehaving custom type input function.

## How to fix

This is an internal contract check. If a custom or extension type is involved, its input function is not honoring the NULL-in/NULL-out rule — fix the type's C input function. For built-in types, capture the statement and report a reproducible case.

## Example

*Illustrative* — an input function that should have returned NULL.

```text
ERROR:  input function 16401 returned non-NULL
```

## Related

- [input function returned null](./input-function-returned-null-d81d3a.md)
- [is not a base type](./is-not-a-base-type.md)
