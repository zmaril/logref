---
message: "number of array dimensions (%d) exceeds the maximum allowed (%d)"
slug: number-of-array-dimensions-exceeds-the-maximum-allowed-f59de1
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:3509"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:1307"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:3520"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:5627"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6145"
  - "postgres/src/backend/utils/adt/arraysubs.c:150"
  - "postgres/src/backend/utils/adt/arraysubs.c:488"
reproduced: false
---

# `number of array dimensions (%d) exceeds the maximum allowed (%d)`

## What it means

An array was constructed with more dimensions than Postgres allows. The placeholders are the requested dimension count and the maximum (6). Arrays are limited to 6 dimensions; nesting beyond that is rejected.

## When it happens

Building a deeply nested array literal, or an operation (concatenation, `array_agg` of arrays) that keeps adding dimensions past six. It usually indicates unintended nesting rather than a real 7+-dimensional need.

## How to fix

Reduce the nesting to at most 6 dimensions. Most cases are accidental — check how the array is being built, since concatenating or aggregating arrays can add a dimension each time. If you genuinely have high-dimensional data, model it differently (for example a flat array plus a dimensions table, or normalized rows).

## Example

*Illustrative* — nesting an array past six dimensions.

```sql
SELECT ARRAY[ARRAY[ARRAY[ARRAY[ARRAY[ARRAY[ARRAY[1]]]]]]];
```

Produces:

```text
ERROR:  number of array dimensions (7) exceeds the maximum allowed (6)
```

## Related

- [array size exceeds the maximum allowed](./array-size-exceeds-the-maximum-allowed-075b47.md)
- [wrong number of array subscripts](./wrong-number-of-array-subscripts.md)
