---
message: "cannot use \"PR\" and \"S\"/\"PL\"/\"MI\"/\"SG\" together"
slug: cannot-use-pr-and-s-pl-mi-sg-together
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1312"
reproduced: false
---

# `cannot use "PR" and "S"/"PL"/"MI"/"SG" together`

## What it means

A `to_char` or `to_number` numeric format template combined the `PR` sign marker with one of `S`, `PL`, `MI`, or `SG`. Those sign markers are mutually exclusive, so `PR` cannot appear alongside them.

## When it happens

It occurs when a formatting template passed to `to_char()` or `to_number()` mixes `PR` (angle-bracket negatives) with another sign marker.

## How to fix

Choose a single sign convention. Keep `PR` on its own, or use one of `S`, `PL`, `MI`, or `SG`, and remove the conflicting marker from the template.

## Example

*Illustrative* — PR mixed with S.

```sql
SELECT to_char(-12, 'S999PR');
-- ERROR:  cannot use "PR" and "S"/"PL"/"MI"/"SG" together
```

## Related

- [cannot use "S" and "PL"/"MI"/"SG"/"PR" together](./cannot-use-s-and-pl-mi-sg-pr-together.md)
- [cannot use "S" and "MI" together](./cannot-use-s-and-mi-together.md)
