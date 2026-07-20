---
message: "cannot XOR bit strings of different sizes"
slug: cannot-xor-bit-strings-of-different-sizes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_STRING_DATA_LENGTH_MISMATCH
    code: "22026"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:1340"
reproduced: false
---

# `cannot XOR bit strings of different sizes`

## What it means

A bitwise `XOR` was applied to two bit strings of different lengths. The bitwise operators on the `bit` and `bit varying` types require both operands to have the same number of bits.

## When it happens

It occurs in an expression such as `a # b` where `a` and `b` are bit strings of unequal length.

## How to fix

Make both operands the same length before the operation. Pad or truncate one side, for example with a length cast, so the two bit strings match.

## Example

*Illustrative* — XOR on mismatched lengths.

```sql
SELECT B'101' # B'1100';
-- ERROR:  cannot XOR bit strings of different sizes
```

## Related

- [cannot subtract inet values of different sizes](./cannot-subtract-inet-values-of-different-sizes.md)
- [column has a collation conflict](./column-has-a-collation-conflict.md)
