---
message: "function %s must return type %s"
slug: function-must-return-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/amcmds.c:262"
  - "postgres/src/backend/commands/event_trigger.c:204"
  - "postgres/src/backend/commands/foreigncmds.c:498"
  - "postgres/src/backend/commands/foreigncmds.c:546"
  - "postgres/src/backend/commands/proclang.c:77"
  - "postgres/src/backend/commands/trigger.c:717"
  - "postgres/src/backend/parser/parse_clause.c:1075"
reproduced: false
---

# `function %s must return type %s`

## What it means

A function was supplied where the system requires one returning a specific type, and its return type does not match. The first placeholder is the function, the second the required type. Support functions attached to types, access methods, event triggers, or foreign-data wrappers must return a prescribed type.

## When it happens

`CREATE` for an access method, foreign-data wrapper handler, event trigger function, or type support function whose return type is wrong — for example an event trigger function not returning `event_trigger`, or an FDW handler not returning `fdw_handler`.

## How to fix

Define the function to return exactly the required type named in the message. Event trigger functions must `RETURNS event_trigger`; FDW handlers `RETURNS fdw_handler`; trigger functions `RETURNS trigger`. Correct the function's return type and recreate it, then retry the command that attaches it.

## Example

*Illustrative* — an event trigger function with the wrong return type.

```sql
CREATE EVENT TRIGGER et ON ddl_command_start EXECUTE FUNCTION plain_func();
```

Produces:

```text
ERROR:  function plain_func must return type event_trigger
```

## Related

- [function %s does not exist](./function-does-not-exist-3ae91e.md)
- [return type mismatch in function declared to return %s](./return-type-mismatch-in-function-declared-to-return.md)
