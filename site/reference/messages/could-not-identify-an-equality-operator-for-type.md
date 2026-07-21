---
message: "could not identify an equality operator for type %s"
slug: could-not-identify-an-equality-operator-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:1068"
  - "postgres/src/backend/commands/indexcmds.c:2506"
  - "postgres/src/backend/commands/indexcmds.c:2524"
  - "postgres/src/backend/executor/execReplication.c:342"
  - "postgres/src/backend/parser/parse_cte.c:301"
  - "postgres/src/backend/parser/parse_oper.c:222"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:1417"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:1560"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:3876"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:4429"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6463"
  - "postgres/src/backend/utils/adt/rowtypes.c:1218"
reproduced: false
---

# `could not identify an equality operator for type %s`

## What it means

An operation that needs to compare values for equality could not find a default equality operator for the type involved. The placeholder is the type. Operations like `DISTINCT`, `GROUP BY`, `UNION`, and array/record equality require a hashable or sortable equality operator, and the type does not provide one.

## When it happens

Using `DISTINCT`/`GROUP BY`/set operations on a column of a type with no equality operator (some custom or opaque types), comparing records/arrays whose element type lacks equality, or aggregates that need to detect equal values.

## How to fix

Provide an equality operator for the type (define one and mark it in a suitable operator class), or avoid the operation on that type — for example do not `GROUP BY` a column whose type cannot be compared. For custom types, ensure a b-tree or hash operator class exists so equality is defined. If the type is genuinely uncomparable, restructure the query to not require equality on it.

## Example

*Illustrative* — DISTINCT on a type without equality.

```sql
SELECT DISTINCT some_opaque_col FROM t;
```

Produces:

```text
ERROR:  could not identify an equality operator for type opaque_type
```

## Related

- [could not identify a comparison function for type %s](./could-not-identify-a-comparison-function-for-type.md)
- [could not identify a hash function for type %s](./could-not-identify-a-hash-function-for-type.md)
