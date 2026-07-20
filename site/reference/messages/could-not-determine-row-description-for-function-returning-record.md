---
message: "could not determine row description for function returning record"
slug: could-not-determine-row-description-for-function-returning-record
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/fmgr/funcapi.c:1983"
reproduced: false
---

# `could not determine row description for function returning record`

## What it means

A function that returns the generic `record` type was called without a way to learn the shape of the record it should produce. PostgreSQL needs the column names and types and could not find them.

## When it happens

It happens when a `record`-returning function is used in a context that does not supply a column definition list and none can be inferred — for example selecting from such a function without an `AS (...)` clause.

## How to fix

Add a column definition list describing the record's columns, for example `SELECT * FROM myfunc(...) AS t(a int, b text)`. Functions returning bare `record` cannot infer their output shape on their own.

## Example

*Illustrative* — a record function used without a column list.

```sql
SELECT * FROM myrecordfunc();
-- ERROR:  could not determine row description for function returning record
```

## Related

- [could not determine actual result type for function declared to return type](./could-not-determine-actual-result-type-for-function-declared-to-return-type.md)
- [could not determine row type for result of](./could-not-determine-row-type-for-result-of.md)
