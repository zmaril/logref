---
message: "sample percentage must be between 0 and 100"
slug: sample-percentage-must-be-between-0-and-100
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLESAMPLE_ARGUMENT
    code: "2202H"
call_sites:
  - "postgres/src/backend/access/tablesample/bernoulli.c:146"
  - "postgres/src/backend/access/tablesample/system.c:149"
reproduced: false
---

# `sample percentage must be between 0 and 100`

## What it means

A `TABLESAMPLE` clause was given a sampling percentage outside the valid range. The fraction of rows to sample must be between 0 and 100 inclusive.

## When it happens

It arises from `SELECT ... TABLESAMPLE BERNOULLI (p)` or `SYSTEM (p)` where `p` is negative or greater than 100.

## How to fix

Use a percentage in the `0`–`100` range. For example `TABLESAMPLE SYSTEM (10)` samples about 10% of the table. Clamp or validate any computed percentage before using it.

## Example

*Illustrative* — a TABLESAMPLE percentage out of range.

```text
ERROR:  sample percentage must be between 0 and 100
```

## Related

- [remainder for hash partition must be less than modulus](./remainder-for-hash-partition-must-be-less-than-modulus.md)
- [ROWS must be positive](./rows-must-be-positive.md)
