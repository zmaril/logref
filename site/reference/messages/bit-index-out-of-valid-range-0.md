---
message: "bit index %d out of valid range (0..%d)"
slug: bit-index-out-of-valid-range-0
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:1822"
  - "postgres/src/backend/utils/adt/varbit.c:1880"
reproduced: false
---

# `bit index %d out of valid range (0..%d)`

## What it means

A bit-string operation addressed a bit position outside the valid range for the value. Bit positions run from zero to one less than the bit length, and the index fell outside that span.

## When it happens

Calling a function such as `get_bit` or `set_bit` on a `bit`/`varbit` value with an index that is negative or at or beyond the value's length — often from computed or off-by-one indexing.

## How to fix

Use a bit index within the value's range, from zero up to the bit length minus one. Check the length with `length()` and validate any computed index, adjusting for the zero-based positions.

## Example

*Illustrative* — a bit index past the end.

```sql
SELECT get_bit(B'101', 5);  -- valid indexes are 0..2
```

## Related

- [array subscript must have type integer](./array-subscript-must-have-type-integer.md)
- [upper bound cannot be less than lower bound](./upper-bound-cannot-be-less-than-lower-bound.md)
