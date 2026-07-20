---
message: "wrong number of array subscripts"
slug: wrong-number-of-array-subscripts
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/contrib/hstore/hstore_io.c:631"
  - "postgres/contrib/hstore/hstore_io.c:660"
  - "postgres/contrib/hstore/hstore_io.c:755"
  - "postgres/contrib/pgcrypto/pgp-pgsql.c:773"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2248"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2270"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2319"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2573"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2918"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6127"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6153"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6164"
  - "postgres/src/backend/utils/adt/json.c:1409"
  - "postgres/src/backend/utils/adt/json.c:1477"
  - "postgres/src/backend/utils/adt/jsonb.c:1320"
  - "postgres/src/backend/utils/adt/jsonb.c:1404"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4725"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4872"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4976"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:5021"
reproduced: false
---

# `wrong number of array subscripts`

## What it means

An array was accessed or built with a subscript count that does not match its dimensionality. A one-dimensional array indexed as if it were two-dimensional (or vice versa) raises this. Postgres arrays have a fixed number of dimensions per value, and subscript expressions must match.

## When it happens

Indexing `a[i][j]` into a 1-D array, assigning into the wrong number of dimensions, or feeding an array-building function subscripts that disagree with the array's shape. It also appears with type input functions (`hstore`, `json`) that construct arrays.

## How to fix

Match the subscript count to the array's dimensionality. Check `array_ndims(a)` to see how many dimensions the value actually has. If you expected a multidimensional array, verify it was constructed as one — nesting `ARRAY[...]` literals inconsistently can yield a different shape than intended.

## Example

*Illustrative* — two subscripts on a one-dimensional array.

```sql
SELECT (ARRAY[1,2,3])[1][2];
```

Produces:

```text
ERROR:  wrong number of array subscripts
```

## Related

- [array must be one-dimensional](./array-must-be-one-dimensional.md)
- [number of array dimensions exceeds the maximum allowed](./number-of-array-dimensions-exceeds-the-maximum-allowed-f59de1.md)
