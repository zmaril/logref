---
message: "cannot OR bit strings of different sizes"
slug: cannot-or-bit-strings-of-different-sizes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_STRING_DATA_LENGTH_MISMATCH
    code: "22026"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:1300"
reproduced: false
---

# `cannot OR bit strings of different sizes`

## What it means

A bitwise OR was applied to two bit strings of different lengths. The `bit`/`varbit` OR operator works position by position, so both operands must have the same number of bits.

## When it happens

It occurs when the `|` operator combines two bit-string values whose lengths differ.

## How to fix

Make both bit strings the same length before combining them — pad the shorter value or truncate the longer one to a common length with the bit-string functions, then apply the OR.

## Example

*Illustrative* — OR of bit strings of unequal length.

```text
ERROR:  cannot OR bit strings of different sizes
```

## Related

- [cannot OR inet values of different sizes](./cannot-or-inet-values-of-different-sizes.md)
- [cannot merge incompatible arrays](./cannot-merge-incompatible-arrays.md)
