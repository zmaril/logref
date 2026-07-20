---
message: "searching for elements in multidimensional arrays is not supported"
slug: searching-for-elements-in-multidimensional-arrays-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/array_userfuncs.c:1355"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:1509"
reproduced: false
---

# `searching for elements in multidimensional arrays is not supported`

## What it means

An operation that searches for a scalar element inside an array (such as the `= ANY` / containment style search, or `array_position`) was applied to a multidimensional array. Element search is only defined for one-dimensional arrays.

## When it happens

It arises when calling `array_position`/`array_positions`, or using element-membership operators, against an array with more than one dimension.

## How to fix

Flatten or slice the array to one dimension before searching, or restructure the data so the searched values live in a one-dimensional array. For multidimensional data, unnest it (`unnest`) and search the resulting rows.

## Example

*Illustrative* — array_position on a 2-D array.

```text
ERROR:  searching for elements in multidimensional arrays is not supported
```

## Related

- [too many array dimensions](./too-many-array-dimensions.md)
- [source array too small](./source-array-too-small.md)
