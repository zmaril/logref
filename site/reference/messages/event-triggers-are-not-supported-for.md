---
message: "event triggers are not supported for %s"
slug: event-triggers-are-not-supported-for
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/event_trigger.c:233"
  - "postgres/src/backend/commands/event_trigger.c:255"
reproduced: false
---

# `event triggers are not supported for %s`

## What it means

A `CREATE EVENT TRIGGER` referenced an event or command tag that does not support event triggers. The `%s` names the unsupported command. Not every command participates in the event-trigger framework.

## When it happens

Defining an event trigger whose `WHEN TAG IN (...)` list includes a command that event triggers do not fire for, or on an event that does not cover it.

## How to fix

Restrict the event trigger to supported command tags. Consult the documented list of commands that fire `ddl_command_start`/`ddl_command_end`/`sql_drop`/`table_rewrite`, and remove unsupported tags.

## Example

*Illustrative* — an unsupported command tag.

```text
ERROR:  event triggers are not supported for ALTER SYSTEM
```

## Related

- [grantable rights not supported for event triggers](./grantable-rights-not-supported-for-event-triggers.md)
- [event trigger promise is not in an event trigger function](./event-trigger-promise-is-not-in-an-event-trigger-function.md)
