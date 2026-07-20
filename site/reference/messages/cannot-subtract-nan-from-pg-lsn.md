---
message: "cannot subtract NaN from pg_lsn"
slug: cannot-subtract-nan-from-pg-lsn
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/pg_lsn.c:289"
reproduced: false
---

# `cannot subtract NaN from pg_lsn`

## What it means

A `numeric` value that was `NaN` was subtracted from a `pg_lsn`. A log sequence number is a concrete byte position, so subtracting a not-a-number offset has no defined result and is rejected.

## When it happens

It occurs in an expression such as `lsn - n` where `n` is a `numeric` `NaN`, often the product of an earlier division or aggregate over empty input.

## How to fix

Ensure the numeric operand is a real number before the subtraction. Guard against `NaN` with a check such as `WHERE n <> 'NaN'` or a `CASE` expression that supplies a default.

## Example

*Illustrative* — subtracting NaN from an LSN.

```sql
SELECT pg_lsn '0/16B3748' - 'NaN'::numeric;
-- ERROR:  cannot subtract NaN from pg_lsn
```

## Related

- [cannot subtract infinite dates](./cannot-subtract-infinite-dates.md)
- [cannot subtract inet values of different sizes](./cannot-subtract-inet-values-of-different-sizes.md)
