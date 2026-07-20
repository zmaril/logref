---
message: "too few arguments for format()"
slug: too-few-arguments-for-format
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/varlena.c:4920"
  - "postgres/src/backend/utils/adt/varlena.c:4977"
reproduced: false
---

# `too few arguments for format()`

## What it means

A call to the `format()` function had more format specifiers than arguments supplied. Each `%s`/`%I`/`%L` (and positional) specifier needs a corresponding argument.

## When it happens

It arises when the format string references more parameters than were passed — for example `format('%s %s', x)` with only one argument, or a positional `%2$s` with no second argument.

## How to fix

Provide an argument for every specifier the format string uses, or reduce the specifiers to match the arguments. Check positional references (`%n$`) point at arguments that exist.

## Example

*Illustrative* — a format() call missing an argument.

```text
ERROR:  too few arguments for format()
```

## Related

- [too many arguments](./too-many-arguments.md)
- [too many function arguments](./too-many-function-arguments.md)
