---
message: "function \"%s\" must be fired AFTER ROW"
slug: function-must-be-fired-after-row
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_TRIGGER_PROTOCOL_VIOLATED
    code: "39P01"
call_sites:
  - "postgres/src/backend/commands/constraint.c:66"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2336"
reproduced: false
---

# `function "%s" must be fired AFTER ROW`

## What it means

A built-in constraint or referential-integrity trigger function was invoked in the wrong trigger timing. The `%s` is the function name. These functions must run as AFTER ROW triggers.

## When it happens

A trigger was defined that calls an internal RI/constraint trigger function with a timing other than AFTER ROW, usually from a hand-created trigger on the wrong events.

## How to fix

Do not define triggers directly on the internal RI/constraint functions. Let foreign keys and constraints create their own triggers. If you must reference such a function, ensure the trigger is AFTER ROW.

## Example

*Illustrative* — an RI function fired at the wrong time.

```text
ERROR:  function "RI_FKey_check_ins" must be fired AFTER ROW
```

## Related

- [function was not called by trigger manager](./function-was-not-called-by-trigger-manager.md)
- [event trigger promise is not in an event trigger function](./event-trigger-promise-is-not-in-an-event-trigger-function.md)
