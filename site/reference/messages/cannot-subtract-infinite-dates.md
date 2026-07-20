---
message: "cannot subtract infinite dates"
slug: cannot-subtract-infinite-dates
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:554"
reproduced: false
---

# `cannot subtract infinite dates`

## What it means

A subtraction was attempted between two `date` values where at least one was the special `infinity` or `-infinity`. The difference of infinite dates is undefined, so the operation is rejected.

## When it happens

It occurs in an expression such as `d1 - d2` when one or both dates hold an infinite value.

## How to fix

Filter out infinite dates before subtracting, or handle them explicitly with a `CASE` expression that returns `NULL` or a chosen sentinel when either operand is infinite.

## Example

*Illustrative* — subtracting infinite dates.

```sql
SELECT date 'infinity' - date '2020-01-01';
-- ERROR:  cannot subtract infinite dates
```

## Related

- [cannot subtract inet values of different sizes](./cannot-subtract-inet-values-of-different-sizes.md)
- [cannot subtract NaN from pg_lsn](./cannot-subtract-nan-from-pg-lsn.md)
