---
message: "event trigger \"%s\" already exists"
slug: event-trigger-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/event_trigger.c:195"
reproduced: false
---

# `event trigger "%s" already exists`

## What it means

A `CREATE EVENT TRIGGER` named an event trigger that already exists. Event-trigger names are global to the database and must be unique.

## When it happens

It fires from `CREATE EVENT TRIGGER name ...` when an event trigger by that name is already defined, often when re-running a setup script.

## How to fix

Choose a different name, or drop the existing event trigger first with `DROP EVENT TRIGGER name`. To make a script idempotent, use `CREATE EVENT TRIGGER` guarded by a check of `pg_event_trigger`, or drop-then-create. There is no `IF NOT EXISTS` clause for event triggers.

## Example

*Illustrative* — the name is already taken.

```sql
CREATE EVENT TRIGGER audit_ddl ON ddl_command_end EXECUTE FUNCTION log_ddl();
-- ERROR when audit_ddl already exists
```

## Related

- [event trigger functions cannot have declared arguments](./event-trigger-functions-cannot-have-declared-arguments.md)
- [event trigger with OID does not exist](./event-trigger-with-oid-does-not-exist.md)
