---
message: "cannot accumulate null arrays"
slug: cannot-accumulate-null-arrays
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:5587"
reproduced: false
---

# `cannot accumulate null arrays`

## What it means

An array-accumulating aggregate such as `array_agg` over array inputs received a null array. The aggregate builds a higher-dimensional array from its inputs, and a null array cannot contribute a well-defined slice.

## When it happens

It occurs when aggregating array values and one of the inputs is null rather than an array.

## How to fix

Exclude null arrays before aggregating, for example with `WHERE arr IS NOT NULL` or a `FILTER (WHERE arr IS NOT NULL)` clause. Every accumulated value must be a non-null array of matching dimensions.

## Example

*Illustrative* — aggregating a null array.

```sql
SELECT array_agg(a) FROM (VALUES (ARRAY[1]), (NULL)) v(a);
```

## Related

- [cannot accumulate empty arrays](./cannot-accumulate-empty-arrays.md)
- [by value of for loop cannot be null](./by-value-of-for-loop-cannot-be-null.md)
