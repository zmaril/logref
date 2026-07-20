---
message: "format specifies argument 0, but arguments are numbered from 1"
slug: format-specifies-argument-0-but-arguments-are-numbered-from-1
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/varlena.c:5136"
  - "postgres/src/backend/utils/adt/varlena.c:5164"
reproduced: false
---

# `format specifies argument 0, but arguments are numbered from 1`

## What it means

A `format()` template used an explicit argument index of `0`. Positional specifiers such as `%1$s` are numbered starting at 1, so `%0$...` is invalid.

## When it happens

Calling `format()` with a template that contains `%0$s` (or another zero index), often a mistake in a hand-written positional format string.

## How to fix

Number positional arguments from 1 (`%1$s`, `%2$s`, and so on). Fix the zero index in the format template.

## Example

*Illustrative* — a zero argument index in format().

```text
ERROR:  format specifies argument 0, but arguments are numbered from 1
```

## Related

- [functions cannot have more than argument](./functions-cannot-have-more-than-argument.md)
- [gen_salt](./gen-salt.md)
