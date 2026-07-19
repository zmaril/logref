---
message: "%s is not allowed in a non-volatile function"
slug: is-not-allowed-in-a-non-volatile-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/functions.c:749"
  - "postgres/src/backend/executor/spi.c:1742"
  - "postgres/src/backend/executor/spi.c:2654"
reproduced: false
---

# `%s is not allowed in a non-volatile function`

## What it means

A function or procedure marked `IMMUTABLE` or `STABLE` attempted an action allowed only in `VOLATILE` routines. Non-volatile routines promise not to modify the database or depend on changing state, and the attempted action breaks that promise.

## When it happens

Executing a data-modifying statement or another volatile action inside a function declared `IMMUTABLE` or `STABLE`, often because the volatility marker was set more strictly than the body actually behaves.

## How to fix

Match the volatility marker to what the function does. If it modifies data or relies on changing state, declare it `VOLATILE`. If it must stay `STABLE` or `IMMUTABLE`, remove the disallowed action from its body. Mislabeled volatility also causes wrong query results, so correcting it is worth doing carefully.

## Example

*Illustrative* — a write inside an IMMUTABLE function.

```sql
CREATE FUNCTION f() RETURNS void IMMUTABLE AS $$ INSERT INTO t VALUES (1); $$ LANGUAGE sql;
```

## Related

- [set-returning functions are not allowed in](./set-returning-functions-are-not-allowed-in.md)
- [trigger functions can only be called as triggers](./trigger-functions-can-only-be-called-as-triggers.md)
