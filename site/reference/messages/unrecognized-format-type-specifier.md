---
message: "unrecognized format() type specifier \"%.*s\""
slug: unrecognized-format-type-specifier
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/varlena.c:4907"
  - "postgres/src/backend/utils/adt/varlena.c:5028"
reproduced: false
---

# `unrecognized format() type specifier "%.*s"`

## What it means

The `format()` function met a type specifier in its format string that is not one of the ones it supports.

## When it happens

It arises from `format()` when a `%` conversion uses a letter other than `s`, `I`, or `L` — for example borrowing a C `printf` specifier like `%d` that `format()` does not implement.

## How to fix

Use only `format()`'s specifiers: `%s` (string), `%I` (quoted identifier), `%L` (quoted literal), and `%%` for a literal percent. Convert values to text yourself if you need numeric formatting.

## Example

*Illustrative* — an unsupported format() specifier.

```text
ERROR:  unrecognized format() type specifier "d"
```

## Related

- [unrecognized encoding: "%s"](./unrecognized-encoding-6df687.md)
- [weight out of range](./weight-out-of-range.md)
