---
message: "function \"%s\" was not called by trigger manager"
slug: function-was-not-called-by-trigger-manager
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_TRIGGER_PROTOCOL_VIOLATED
    code: "39P01"
call_sites:
  - "postgres/src/backend/commands/constraint.c:59"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2327"
reproduced: false
---

# `function "%s" was not called by trigger manager`

## What it means

A function that only works as a trigger was called directly instead. The `%s` is the function name. Trigger functions rely on trigger context (the `TriggerData`) that a plain call does not provide.

## When it happens

Invoking a trigger function (an internal RI/constraint function, or a user trigger function) with a normal `SELECT`/`CALL` rather than through a fired trigger.

## How to fix

Call trigger functions only by attaching them to a trigger, not directly. Create the appropriate trigger and let it fire the function; do not `SELECT` it.

## Example

*Illustrative* — calling a trigger function directly.

```text
ERROR:  function "my_trigger_fn" was not called by trigger manager
```

## Related

- [function must be fired AFTER ROW](./function-must-be-fired-after-row.md)
- [event trigger promise is not in an event trigger function](./event-trigger-promise-is-not-in-an-event-trigger-function.md)
