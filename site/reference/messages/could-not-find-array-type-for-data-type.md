---
message: "could not find array type for data type %s"
slug: could-not-find-array-type-for-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/nodes/nodeFuncs.c:116"
  - "postgres/src/backend/nodes/nodeFuncs.c:147"
  - "postgres/src/backend/parser/parse_coerce.c:2600"
  - "postgres/src/backend/parser/parse_coerce.c:2738"
  - "postgres/src/backend/parser/parse_coerce.c:2785"
  - "postgres/src/backend/parser/parse_expr.c:2150"
  - "postgres/src/backend/parser/parse_func.c:728"
  - "postgres/src/backend/parser/parse_oper.c:918"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:1957"
  - "postgres/src/backend/utils/fmgr/funcapi.c:669"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:2122"
reproduced: false
---

# `could not find array type for data type %s`

## What it means

An operation needed the array type corresponding to a given element type, and none exists. The placeholder is the element type. Most built-in types have an automatically created array type, but some (pseudo-types, certain internal or composite types) do not.

## When it happens

`array_agg` or `ARRAY[...]` over values of a type that has no array type, building an array of a pseudo-type, or a polymorphic function trying to produce `anyarray` from an element type lacking an array form.

## How to fix

Use an element type that has an array type, or cast the values to one that does. Pseudo-types (`record`, `cstring`, `internal`) and some special types cannot be put in arrays. If it is a custom composite/base type, ensure its array type was created (base types normally get one automatically via `CREATE TYPE`).

## Example

*Illustrative* — aggregating a type with no array type.

```sql
SELECT array_agg(x) FROM (SELECT NULL::record AS x) s;
```

Produces:

```text
ERROR:  could not find array type for data type record
```

## Related

- [could not determine input data type](./could-not-determine-input-data-type.md)
- [wrong number of array subscripts](./wrong-number-of-array-subscripts.md)
