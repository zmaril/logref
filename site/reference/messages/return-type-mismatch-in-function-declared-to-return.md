---
message: "return type mismatch in function declared to return %s"
slug: return-type-mismatch-in-function-declared-to-return
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/executor/functions.c:1184"
  - "postgres/src/backend/executor/functions.c:2223"
  - "postgres/src/backend/executor/functions.c:2261"
  - "postgres/src/backend/executor/functions.c:2275"
  - "postgres/src/backend/executor/functions.c:2365"
  - "postgres/src/backend/executor/functions.c:2398"
  - "postgres/src/backend/executor/functions.c:2412"
reproduced: false
---

# `return type mismatch in function declared to return %s`

## What it means

The body of a SQL or PL function produced a value whose type does not match the function's declared return type. The placeholder is the declared type. Postgres checks that the final expression (or `RETURN`) matches the declaration and rejects a mismatch.

## When it happens

A function whose last `SELECT`/`RETURN` yields a different type or column set than declared — for example `RETURNS integer` but the body returns `text`, or `RETURNS TABLE(...)` whose columns do not line up. It surfaces at creation (for SQL functions checked eagerly) or at call time.

## How to fix

Make the body return exactly the declared type — cast the final expression, or fix the declaration to match what the body produces. For `RETURNS TABLE`/`SETOF composite`, ensure the column count, order, and types match. Add explicit casts where the body's natural type differs from the declaration.

## Example

*Illustrative* — a body returning the wrong type.

```sql
CREATE FUNCTION f() RETURNS integer AS $$ SELECT 'x' $$ LANGUAGE sql;
```

Produces:

```text
ERROR:  return type mismatch in function declared to return integer
DETAIL:  Actual return type is text.
```

## Related

- [function %s must return type %s](./function-must-return-type.md)
- [return type must be a row type](./return-type-must-be-a-row-type.md)
