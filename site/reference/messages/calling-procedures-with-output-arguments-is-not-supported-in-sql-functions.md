---
message: "calling procedures with output arguments is not supported in SQL functions"
slug: calling-procedures-with-output-arguments-is-not-supported-in-sql-functions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/functions.c:2074"
reproduced: false
---

# `calling procedures with output arguments is not supported in SQL functions`

## What it means

A function written in the SQL language used `CALL` on a procedure that has `OUT` or `INOUT` parameters. SQL-language functions cannot capture a procedure's output arguments.

## When it happens

It occurs when a `LANGUAGE sql` function or a SQL-standard function body contains a `CALL proc(...)` where `proc` declares output parameters.

## How to fix

Move the `CALL` into a PL/pgSQL function, which can receive output arguments into variables, or invoke the procedure directly with `CALL` at the top level. SQL-language functions do not support output arguments from procedure calls.

## Example

*Illustrative* — CALL with OUT args inside a SQL function.

```sql
CREATE FUNCTION f() RETURNS void LANGUAGE sql AS $$ CALL myproc(1, NULL) $$;
```

## Related

- [can only be executed as a top-level statement](./can-only-be-executed-as-a-top-level-statement.md)
- [cannot accept a value of a shell type](./cannot-accept-a-value-of-a-shell-type.md)
