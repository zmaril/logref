---
message: "array must not contain nulls"
slug: array-must-not-contain-nulls
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/contrib/ltree/_ltree_gist.c:67"
  - "postgres/contrib/ltree/_ltree_gist.c:489"
  - "postgres/contrib/ltree/_ltree_op.c:48"
  - "postgres/contrib/ltree/_ltree_op.c:148"
  - "postgres/contrib/ltree/_ltree_op.c:306"
  - "postgres/contrib/ltree/lquery_op.c:300"
  - "postgres/contrib/ltree/ltree_gist.c:602"
  - "postgres/contrib/pg_surgery/heap_surgery.c:376"
  - "postgres/src/backend/replication/logical/logicalfuncs.c:160"
  - "postgres/src/backend/utils/adt/waitfuncs.c:66"
reproduced: false
---

# `array must not contain nulls`

## What it means

An operation that forbids NULL elements was given an array containing one. Some index types, extension functions (`ltree`, `intarray`), and surgery/logical functions require NULL-free arrays because they cannot represent or process NULL elements meaningfully.

## When it happens

Passing an array with NULLs to a function or operator that disallows them — `ltree`/`lquery` operations, certain GiST/GIN operations, `pg_surgery` functions, or logical-replication helpers. The array itself is valid SQL; the specific consumer rejects NULLs.

## How to fix

Remove NULL elements before the operation, for example with `array_remove(arr, NULL)` or by filtering them out during construction. If NULLs are meaningful to your data, that consumer is not the right tool. Ensure array-building aggregates do not introduce NULLs where the downstream operation forbids them.

## Example

*Illustrative* — a NULL element where none is allowed.

```sql
SELECT '{a,b}'::ltree[] @> ARRAY['a', NULL]::ltree[];
```

Produces:

```text
ERROR:  array must not contain nulls
```

## Related

- [array must be one-dimensional](./array-must-be-one-dimensional.md)
- [wrong number of array subscripts](./wrong-number-of-array-subscripts.md)
