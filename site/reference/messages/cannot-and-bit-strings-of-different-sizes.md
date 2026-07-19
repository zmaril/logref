---
message: "cannot AND bit strings of different sizes"
slug: cannot-and-bit-strings-of-different-sizes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_STRING_DATA_LENGTH_MISMATCH
    code: "22026"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:1259"
reproduced: false
---

# `cannot AND bit strings of different sizes`

## What it means

A bitwise `AND` was applied to two bit strings whose lengths differ. The `&` operator on `bit`/`bit varying` requires both operands to have the same number of bits, because the result is computed bit for bit.

## When it happens

It occurs when evaluating `a & b` where `a` and `b` are bit strings of unequal length.

## How to fix

Make both operands the same length before combining them — pad or truncate one side, or cast to a common `bit(n)` width. Bitwise operators do not extend the shorter operand automatically.

## Example

*Illustrative* — bit strings of different widths.

```sql
SELECT B'1010' & B'11';
```

## Related

- [cannot and inet values of different sizes](./cannot-and-inet-values-of-different-sizes.md)
- [cannot coerce to boolean](./cannot-coerce-to-boolean.md)
