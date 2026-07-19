---
message: "cannot use \"S\" and \"MI\" together"
slug: cannot-use-s-and-mi-together
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1283"
reproduced: false
---

# `cannot use "S" and "MI" together`

## What it means

A `to_char` or `to_number` numeric format template combined the `S` sign marker with `MI`. Both control how the sign is shown, and they cannot appear in the same template.

## When it happens

It occurs when a formatting template passed to `to_char()` or `to_number()` includes both `S` and `MI`.

## How to fix

Keep one sign marker. Use `S` for a leading or trailing plus/minus, or `MI` for a trailing minus on negatives, and remove the other.

## Example

*Illustrative* — S and MI together.

```sql
SELECT to_char(-12, 'S999MI');
-- ERROR:  cannot use "S" and "MI" together
```

## Related

- [cannot use "S" and "PL" together](./cannot-use-s-and-pl-together.md)
- [cannot use "S" and "SG" together](./cannot-use-s-and-sg-together.md)
