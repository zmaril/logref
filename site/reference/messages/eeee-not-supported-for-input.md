---
message: "\"EEEE\" not supported for input"
slug: eeee-not-supported-for-input
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:5779"
reproduced: false
---

# `"EEEE" not supported for input`

## What it means

A `to_number` call used the `EEEE` (scientific notation) format element. `EEEE` is supported only for output formatting with `to_char`, not for parsing input with `to_number`.

## When it happens

It fires from `to_number()` when its format template contains `EEEE`.

## How to fix

Do not use `EEEE` in a `to_number` template. To parse scientific-notation text, cast it directly to a numeric type (for example `'1.2345e3'::numeric`), which understands exponent notation.

## Example

*Illustrative* — EEEE in to_number.

```sql
SELECT to_number('1.2E3', '9.9EEEE');
-- "EEEE" not supported for input
```

## Related

- ["EEEE" is incompatible with other formats](./eeee-is-incompatible-with-other-formats.md)
- ["EEEE" must be the last pattern used](./eeee-must-be-the-last-pattern-used.md)
