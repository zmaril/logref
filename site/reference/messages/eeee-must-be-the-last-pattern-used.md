---
message: "\"EEEE\" must be the last pattern used"
slug: eeee-must-be-the-last-pattern-used
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1192"
reproduced: false
---

# `"EEEE" must be the last pattern used`

## What it means

A `to_char`/`to_number` numeric format string placed pattern elements after the `EEEE` (scientific notation) marker. `EEEE` must be the final element of the template.

## When it happens

It fires while parsing a numeric format template where something follows `EEEE`.

## How to fix

Move `EEEE` to the end of the format string, with the mantissa digits before it, for example `'9.99EEEE'`. Remove any elements after `EEEE`.

## Example

*Illustrative* — content after EEEE.

```sql
SELECT to_char(1234.5, '9.9EEEE9');
-- "EEEE" must be the last pattern used
```

## Related

- ["EEEE" is incompatible with other formats](./eeee-is-incompatible-with-other-formats.md)
- ["EEEE" not supported for input](./eeee-not-supported-for-input.md)
