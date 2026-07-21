---
message: "cannot use \"S\" and \"PL\" together"
slug: cannot-use-s-and-pl-together
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1293"
reproduced: false
---

# `cannot use "S" and "PL" together`

## What it means

A `to_char` or `to_number` numeric format template combined the `S` sign marker with `PL`. Both control sign display, so they cannot appear in the same template.

## When it happens

It occurs when a formatting template passed to `to_char()` or `to_number()` includes both `S` and `PL`.

## How to fix

Keep one sign marker. Use `S` for a signed value or `PL` for a leading plus on positives, and remove the other.

## Example

*Illustrative* — S and PL together.

```sql
SELECT to_char(12, 'PL999S');
-- ERROR:  cannot use "S" and "PL" together
```

## Related

- [cannot use "S" and "MI" together](./cannot-use-s-and-mi-together.md)
- [cannot use "S" and "SG" together](./cannot-use-s-and-sg-together.md)
