---
message: "array size exceeds the maximum allowed (%zu)"
slug: array-size-exceeds-the-maximum-allowed-075b47
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/utils/adt/array_expanded.c:274"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:1071"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:1536"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2344"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2359"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2621"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2637"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2898"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2952"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2967"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:3309"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:3550"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:5390"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:5612"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6238"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6584"
reproduced: false
---

# `array size exceeds the maximum allowed (%zu)`

## What it means

An array grew (or was asked to be) larger than Postgres allows in bytes. The placeholder is the offending size. Arrays are limited to 1 GB (the maximum size of a variable-length datum), and building one past that limit is rejected.

## When it happens

`array_agg` or `array_cat` over a very large input, constructing a huge array literal, or `array_fill`/`generate` producing too many elements. It often shows up when aggregating unbounded data into a single array value.

## How to fix

Do not accumulate unbounded data into one array. Aggregate into rows instead (keep the set as a table, not an array), or chunk the work so each array stays well under 1 GB. If you need a large collection, reconsider the data model — a normalized table or a `bytea`/large object may fit better than a giant array.

## Example

*Illustrative* — aggregating too much into one array.

```sql
SELECT array_agg(g) FROM generate_series(1, 300000000) g;
```

Produces:

```text
ERROR:  array size exceeds the maximum allowed (1073741823)
```

## Related

- [number of array dimensions exceeds the maximum allowed](./number-of-array-dimensions-exceeds-the-maximum-allowed-f59de1.md)
- [out of memory](./out-of-memory-6bf5c2.md)
