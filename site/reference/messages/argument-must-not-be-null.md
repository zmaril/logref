---
message: "argument \"%s\" must not be null"
slug: argument-must-not-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/statistics/stat_utils.c:59"
reproduced: false
---

# `argument "%s" must not be null`

## What it means

A function was passed NULL for an argument that does not accept NULL, so it cannot proceed.

## When it happens

It occurs when a named argument that must be non-null receives NULL — common in configuration, administrative, and constructor functions that reject null inputs.

## How to fix

Provide a non-null value for the named argument. Guard the call so NULLs are filtered or defaulted (for example with `coalesce`), and check why the value was NULL upstream.

## Example

*Illustrative* — a NULL passed where it is not allowed.

```text
ERROR:  argument "slot_name" must not be null
```

## Related

- [argument key must not be null](./argument-key-must-not-be-null.md)
- [argument exceeds the maximum length of bytes](./argument-exceeds-the-maximum-length-of-bytes.md)
