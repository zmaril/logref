---
message: "%s can only be called in a sql_drop event trigger function"
slug: can-only-be-called-in-a-sql-drop-event-trigger-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_EVENT_TRIGGER_PROTOCOL_VIOLATED
    code: "39P03"
call_sites:
  - "postgres/src/backend/commands/event_trigger.c:1544"
reproduced: false
---

# `%s can only be called in a sql_drop event trigger function`

## What it means

A function that reports dropped objects was called outside a `sql_drop` event-trigger function. The placeholder is the function name. It reads state that only exists while a `sql_drop` event trigger is firing.

## When it happens

It occurs when calling `pg_event_trigger_dropped_objects()` from a function that is not attached to the `sql_drop` event, or from ordinary code.

## How to fix

Call this function only from a trigger function attached to the `sql_drop` event. Create the event trigger `ON sql_drop` and invoke the function inside its handler, where the dropped-object list is populated.

## Example

*Illustrative* — the function called outside sql_drop.

```sql
SELECT pg_event_trigger_dropped_objects();
```

## Related

- [can only be called in an event trigger function](./can-only-be-called-in-an-event-trigger-function.md)
- [can only be called from an sql script executed by create extension](./can-only-be-called-from-an-sql-script-executed-by-create-extension.md)
