---
message: "event trigger functions cannot have declared arguments"
slug: event-trigger-functions-cannot-have-declared-arguments
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_comp.c:631"
reproduced: false
---

# `event trigger functions cannot have declared arguments`

## What it means

A function intended for use as an event trigger was defined with declared parameters. Event-trigger functions must take no arguments and return the `event_trigger` pseudo-type; PostgreSQL passes context through a global structure instead.

## When it happens

It fires when compiling or attaching a PL/pgSQL (or other language) function that returns `event_trigger` but declares one or more parameters.

## How to fix

Remove all declared parameters. Define the function with an empty argument list returning `event_trigger`, and read event context inside it with functions such as `pg_event_trigger_ddl_commands()` or the `TG_*` variables. Then attach it with `CREATE EVENT TRIGGER`.

## Example

*Illustrative* — event-trigger functions take no arguments.

```sql
CREATE FUNCTION f() RETURNS event_trigger AS $$ BEGIN END $$ LANGUAGE plpgsql;
```

## Related

- [event trigger "%s" already exists](./event-trigger-already-exists.md)
- [event trigger with OID does not exist](./event-trigger-with-oid-does-not-exist.md)
