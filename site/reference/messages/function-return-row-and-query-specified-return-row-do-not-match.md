---
message: "function return row and query-specified return row do not match"
slug: function-return-row-and-query-specified-return-row-do-not-match
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/executor/execSRF.c:951"
  - "postgres/src/backend/executor/execSRF.c:967"
  - "postgres/src/backend/executor/execSRF.c:977"
reproduced: false
---

# `function return row and query-specified return row do not match`

## What it means

A set-returning function called with a column definition list (or against an expected row type) produced rows whose structure does not match what the query specified. The placeholder-free message means the actual row shape — number or types of columns — differs from the declared one.

## When it happens

Calling a function returning `record` with a `AS (col type, ...)` list that does not match the rows it returns, or a `SETOF record`/`RETURNS TABLE` function whose output columns differ from the query's expectation.

## How to fix

Align the column definition list with the function's actual output: match the number, order, and types of columns exactly. For `RETURNS record` functions, provide the correct `AS (...)` list; for `RETURNS TABLE`/composite functions, ensure the returned rows match the declared columns.

## Example

*Illustrative* — a mismatched record column list.

```sql
SELECT * FROM myfunc() AS t(a int, b int);  -- row shapes do not match
```

## Related

- [cannot return non-composite value from function returning composite type](./cannot-return-non-composite-value-from-function-returning-composite-type.md)
- [number of source and target fields in assignment does not match](./number-of-source-and-target-fields-in-assignment-does-not-match.md)
