---
message: "too many array dimensions"
slug: too-many-array-dimensions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:1480"
  - "postgres/src/backend/commands/tablecmds.c:15497"
reproduced: false
---

# `too many array dimensions`

## What it means

An array was constructed or requested with more dimensions than Postgres allows. Arrays are limited to a fixed maximum number of dimensions.

## When it happens

It arises when building or reshaping an array whose dimensionality exceeds the maximum — for example deeply nested array literals or an operation that would add dimensions past the cap.

## How to fix

Reduce the array's dimensionality to within the allowed maximum. Restructure very deeply nested data using composite types or a normalized table rather than pushing array dimensions beyond the limit.

## Example

*Illustrative* — an array exceeding the dimension limit.

```text
ERROR:  too many array dimensions
```

## Related

- [searching for elements in multidimensional arrays is not supported](./searching-for-elements-in-multidimensional-arrays-is-not-supported.md)
- [row is too big: size %zu, maximum size %zu](./row-is-too-big-size-maximum-size.md)
