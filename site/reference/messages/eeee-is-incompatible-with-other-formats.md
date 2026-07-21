---
message: "\"EEEE\" is incompatible with other formats"
slug: eeee-is-incompatible-with-other-formats
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1348"
reproduced: false
---

# `"EEEE" is incompatible with other formats`

## What it means

A `to_char`/`to_number` numeric format string combined the `EEEE` (scientific notation) pattern with other format patterns that cannot coexist with it. The `EEEE` marker must stand largely on its own.

## When it happens

It fires while parsing a numeric format template that mixes `EEEE` with incompatible elements.

## How to fix

Use `EEEE` with only the mantissa digits it allows (for example `'9.99EEEE'`), and drop incompatible format elements such as thousands separators or currency symbols.

## Example

*Illustrative* — EEEE mixed with an incompatible element.

```sql
SELECT to_char(1234.5, '9,999EEEE');
-- "EEEE" is incompatible with other formats
```

## Related

- ["EEEE" must be the last pattern used](./eeee-must-be-the-last-pattern-used.md)
- ["EEEE" not supported for input](./eeee-not-supported-for-input.md)
