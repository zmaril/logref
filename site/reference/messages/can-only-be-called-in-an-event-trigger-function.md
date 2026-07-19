---
message: "%s can only be called in an event trigger function"
slug: can-only-be-called-in-an-event-trigger-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_EVENT_TRIGGER_PROTOCOL_VIOLATED
    code: "39P03"
call_sites:
  - "postgres/src/backend/commands/event_trigger.c:2074"
reproduced: false
---

# `%s can only be called in an event trigger function`

## What it means

A function that reads event-trigger context was called outside an event-trigger function. The placeholder is the function name. Its data only exists while an event trigger is executing.

## When it happens

It occurs when calling a function such as `pg_event_trigger_ddl_commands()` or `tg_tag`-style accessors from ordinary code rather than from an event-trigger handler.

## How to fix

Call the function only from within an event-trigger function. Define the event trigger and invoke the accessor inside its handler, where the event context is available.

## Example

*Illustrative* — an event-trigger accessor called directly.

```sql
SELECT pg_event_trigger_ddl_commands();
```

## Related

- [can only be called in a sql drop event trigger function](./can-only-be-called-in-a-sql-drop-event-trigger-function.md)
- [can only be executed as a top-level statement](./can-only-be-executed-as-a-top-level-statement.md)
