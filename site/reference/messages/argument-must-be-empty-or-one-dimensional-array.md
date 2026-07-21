---
message: "argument must be empty or one-dimensional array"
slug: argument-must-be-empty-or-one-dimensional-array
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_EXCEPTION
    code: "22000"
call_sites:
  - "postgres/contrib/pg_surgery/heap_surgery.c:381"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:173"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:258"
reproduced: false
---

# `argument must be empty or one-dimensional array`

## What it means

A function that accepts an array (here `pg_surgery`'s heap-repair functions) was given a multidimensional array where only a flat, one-dimensional array (or an empty one) is allowed. Postgres arrays can be multidimensional, but this function only handles a single dimension.

## When it happens

Passing a 2-D or higher array to a function documented to take a one-dimensional list of values — for example constructing the argument with nested `ARRAY[[...]]` or an aggregate that produced a multidimensional result.

## How to fix

Flatten the input to one dimension. Build the argument as a simple `ARRAY[a, b, c]`, or unnest and re-aggregate a multidimensional value into a 1-D array before calling. An empty array is also accepted where no elements are intended.

## Example

*Illustrative* — a multidimensional array where 1-D is required.

```sql
SELECT heap_force_kill('t'::regclass, ARRAY[[1,2],[3,4]]::tid[]);
```

## Related

- [array must be one-dimensional](./array-must-be-one-dimensional.md)
- [cannot work with arrays containing NULLs](./cannot-work-with-arrays-containing-nulls.md)
