---
message: "could not determine actual result type for function \"%s\" declared to return type %s"
slug: could-not-determine-actual-result-type-for-function-declared-to-return-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/fmgr/funcapi.c:496"
reproduced: false
---

# `could not determine actual result type for function "%s" declared to return type %s`

## What it means

A function declared to return a polymorphic or record type did not resolve to a concrete result type in this call. The `%s` values name the function and its declared return type. PostgreSQL could not work out the actual type it should produce.

## When it happens

It happens when calling a function that returns `anyelement`, `record`, or a similar type in a context that does not supply the concrete result type — for example a record-returning function used without a column definition list.

## How to fix

Provide the concrete result type. For record-returning functions, add a column definition list (`... AS t(col1 int, col2 text)`); for polymorphic returns, make sure an argument pins the type. Cast an input if needed.

## Example

*Illustrative* — a record function called without a column list.

```sql
SELECT * FROM json_to_record('{"a":1}');
-- ERROR:  could not determine actual result type for function "json_to_record" declared to return type record
```

## Related

- [could not determine row description for function returning record](./could-not-determine-row-description-for-function-returning-record.md)
- [could not determine actual return type for polymorphic function](./could-not-determine-actual-return-type-for-polymorphic-function.md)
