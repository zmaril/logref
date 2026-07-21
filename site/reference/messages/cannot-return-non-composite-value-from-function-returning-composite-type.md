---
message: "cannot return non-composite value from function returning composite type"
slug: cannot-return-non-composite-value-from-function-returning-composite-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3284"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3327"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3503"
reproduced: false
---

# `cannot return non-composite value from function returning composite type`

## What it means

A function declared to return a composite type (a row/record type) tried to return a scalar. The return value's shape must match the declared composite type; a single non-composite value cannot stand in for a row.

## When it happens

In PL/pgSQL or another language, `RETURN`ing a scalar expression from a function whose result type is a composite/row type, or building the return value without constructing the full row.

## How to fix

Return a row value that matches the composite type: use `RETURN ROW(...)`, `RETURN` a record variable of the right type, or `RETURN QUERY` a row source. If the function should really return a scalar, change its declared return type to that scalar type.

## Example

*Illustrative* — returning a scalar from a composite-returning function.

```sql
-- function returns a row type but does:
RETURN 1;  -- cannot return non-composite value ...
```

## Related

- [function return row and query-specified return row do not match](./function-return-row-and-query-specified-return-row-do-not-match.md)
- [number of source and target fields in assignment does not match](./number-of-source-and-target-fields-in-assignment-does-not-match.md)
