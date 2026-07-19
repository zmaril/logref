---
message: "cannot use \"S\" and \"SG\" together"
slug: cannot-use-s-and-sg-together
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1303"
reproduced: false
---

# `cannot use "S" and "SG" together`

## What it means

A `to_char` or `to_number` numeric format template combined the `S` sign marker with `SG`. Both control how the sign is rendered, so they cannot appear in the same template.

## When it happens

It occurs when a formatting template passed to `to_char()` or `to_number()` includes both `S` and `SG`.

## How to fix

Keep one sign marker. Use `S` or `SG`, not both, and remove the conflicting marker from the template.

## Example

*Illustrative* — S and SG together.

```sql
SELECT to_char(-12, 'S999SG');
-- ERROR:  cannot use "S" and "SG" together
```

## Related

- [cannot use "S" and "PL" together](./cannot-use-s-and-pl-together.md)
- [cannot use "S" and "MI" together](./cannot-use-s-and-mi-together.md)
