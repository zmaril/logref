---
message: "event trigger \"%s\" does not exist"
slug: event-trigger-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/event_trigger.c:442"
  - "postgres/src/backend/commands/event_trigger.c:494"
  - "postgres/src/backend/commands/event_trigger.c:588"
reproduced: false
---

# `event trigger "%s" does not exist`

## What it means

A command referenced an event trigger by name that does not exist. The placeholder is the name. Event triggers fire on DDL events; `ALTER`/`DROP EVENT TRIGGER` or a comment on one requires the named trigger to exist.

## When it happens

`ALTER EVENT TRIGGER x ...`, `DROP EVENT TRIGGER x`, or `COMMENT ON EVENT TRIGGER x` where `x` is misspelled or was already dropped.

## How to fix

List event triggers with `\dy` (or `SELECT evtname FROM pg_event_trigger`) and use the correct name, or use `DROP EVENT TRIGGER IF EXISTS` for idempotent scripts. Check spelling and case.

## Example

*Illustrative* — altering a missing event trigger.

```sql
ALTER EVENT TRIGGER nope DISABLE;  -- event trigger "nope" does not exist
```

## Related

- [foreign-data wrapper does not exist](./foreign-data-wrapper-does-not-exist.md)
- [publication does not exist](./publication-does-not-exist.md)
