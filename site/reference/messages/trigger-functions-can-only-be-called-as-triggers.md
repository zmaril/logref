---
message: "trigger functions can only be called as triggers"
slug: trigger-functions-can-only-be-called-as-triggers
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_comp.c:453"
  - "postgres/src/pl/plpython/plpy_procedure.c:235"
  - "postgres/src/pl/tcl/pltcl.c:1633"
reproduced: false
---

# `trigger functions can only be called as triggers`

## What it means

A function written to run as a trigger was invoked directly as an ordinary function. Trigger functions rely on trigger context — the row and event information the trigger machinery supplies — which is absent when they are called normally, so the call is rejected.

## When it happens

Calling a function declared to return `trigger` (or the language's trigger type) from a `SELECT` or another expression, instead of letting it fire through a `CREATE TRIGGER` binding.

## How to fix

Invoke the function by attaching it to a table with `CREATE TRIGGER` and performing the triggering action, not by calling it directly. If you need callable logic, put the shared work in a regular function and have the trigger function call that.

## Example

*Illustrative* — calling a trigger function directly.

```sql
SELECT my_trigger_fn();  -- only callable as a trigger
```

## Related

- [is not allowed in a non-volatile function](./is-not-allowed-in-a-non-volatile-function.md)
- [relation cannot have triggers](./relation-cannot-have-triggers.md)
