---
message: "cannot use \"S\" and \"PL\"/\"MI\"/\"SG\"/\"PR\" together"
slug: cannot-use-s-and-pl-mi-sg-pr-together
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1263"
reproduced: false
---

# `cannot use "S" and "PL"/"MI"/"SG"/"PR" together`

## What it means

A `to_char` or `to_number` numeric format template combined the `S` sign marker with one of `PL`, `MI`, `SG`, or `PR`. The `S` marker is exclusive with those other sign markers, so it cannot appear alongside them.

## When it happens

It occurs when a formatting template mixes `S` with any of `PL`, `MI`, `SG`, or `PR`.

## How to fix

Choose one sign convention. Keep `S`, or use one of the others, and remove the conflicting marker from the template.

## Example

*Illustrative* — S mixed with PL.

```sql
SELECT to_char(12, 'S999PL');
-- ERROR:  cannot use "S" and "PL"/"MI"/"SG"/"PR" together
```

## Related

- [cannot use "PR" and "S"/"PL"/"MI"/"SG" together](./cannot-use-pr-and-s-pl-mi-sg-together.md)
- [cannot use "S" and "MI" together](./cannot-use-s-and-mi-together.md)
