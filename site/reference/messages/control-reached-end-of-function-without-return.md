---
message: "control reached end of function without RETURN"
slug: control-reached-end-of-function-without-return
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_S_R_E_FUNCTION_EXECUTED_NO_RETURN_STATEMENT
    code: "2F005"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:640"
reproduced: false
---

# `control reached end of function without RETURN`

## What it means

A PL/pgSQL function declared to return a value ran off the end of its body without executing a `RETURN`. A function with a return type must return a value on every path.

## When it happens

It happens at runtime when a non-void PL/pgSQL function reaches the end of its code without hitting a `RETURN`, typically because a conditional branch omitted one.

## How to fix

Ensure every execution path ends in a `RETURN` with an appropriate value. Add a final `RETURN` or a `RETURN` in each branch. If the function should sometimes return nothing, return `NULL` explicitly.

## Example

*Illustrative* — a function path without RETURN.

```sql
CREATE FUNCTION f(x int) RETURNS int AS $$
BEGIN
  IF x > 0 THEN RETURN 1; END IF;
END;
$$ LANGUAGE plpgsql;
SELECT f(-1);
-- ERROR:  control reached end of function without RETURN
```

## Related

- [conversion does not exist](./conversion-does-not-exist.md)
- [conversion already exists](./conversion-already-exists.md)
