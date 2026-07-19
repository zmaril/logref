---
message: "cannot accumulate empty arrays"
slug: cannot-accumulate-empty-arrays
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:5623"
reproduced: false
---

# `cannot accumulate empty arrays`

## What it means

An array-accumulating aggregate such as `array_agg` over array inputs was given an empty array. The aggregate builds a higher-dimensional array from equally shaped inputs, and an empty array has no consistent shape to add.

## When it happens

It occurs when aggregating array values with `array_agg` (or a similar array accumulator) and one of the inputs is an empty array.

## How to fix

Filter out empty arrays before aggregating, for example with `WHERE cardinality(arr) > 0` or a `FILTER` clause on the aggregate. All accumulated arrays must be non-empty and share dimensions.

## Example

*Illustrative* — aggregating an empty array.

```sql
SELECT array_agg(a) FROM (VALUES (ARRAY[1]), (ARRAY[]::int[])) v(a);
```

## Related

- [cannot accumulate null arrays](./cannot-accumulate-null-arrays.md)
- [by value of for loop must be greater than zero](./by-value-of-for-loop-must-be-greater-than-zero.md)
