---
message: "upper bound cannot be less than lower bound"
slug: upper-bound-cannot-be-less-than-lower-bound
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2943"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2988"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:3003"
reproduced: false
---

# `upper bound cannot be less than lower bound`

## What it means

An array slice or dimension was specified with an upper bound smaller than its lower bound. A bound range must be non-empty in the low-to-high direction, so an upper bound below the lower bound is invalid.

## When it happens

Constructing an array with explicit dimension bounds where the upper is less than the lower, or writing an array slice whose bounds are reversed.

## How to fix

Order the bounds so the upper is at least the lower. Check any computed bounds, and if a slice could legitimately be empty, handle that case explicitly rather than passing reversed bounds.

## Example

*Illustrative* — reversed array bounds.

```sql
SELECT ('[5:1]={}'::int[]);  -- upper bound below lower bound
```

## Related

- [bit index out of valid range 0](./bit-index-out-of-valid-range-0.md)
- [array subscript must have type integer](./array-subscript-must-have-type-integer.md)
