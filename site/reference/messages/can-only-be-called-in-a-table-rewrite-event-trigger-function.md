---
message: "%s can only be called in a table_rewrite event trigger function"
slug: can-only-be-called-in-a-table-rewrite-event-trigger-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_EVENT_TRIGGER_PROTOCOL_VIOLATED
    code: "39P03"
call_sites:
  - "postgres/src/backend/commands/event_trigger.c:1637"
  - "postgres/src/backend/commands/event_trigger.c:1658"
reproduced: false
---

# `%s can only be called in a table_rewrite event trigger function`

## What it means

A function that reports table-rewrite context (such as `pg_event_trigger_table_rewrite_oid()` or `pg_event_trigger_table_rewrite_reason()`) was called from outside a `table_rewrite` event trigger. The placeholder is the function name. These functions only have meaning while that event is firing.

## When it happens

Calling one of the `table_rewrite` reporting functions directly in a query, or from an event trigger declared on a different event (such as `ddl_command_start`) rather than on `table_rewrite`.

## How to fix

Call these functions only from a function attached to the `table_rewrite` event. Declare the trigger with `CREATE EVENT TRIGGER ... ON table_rewrite` and invoke the reporting functions from its body, where the rewrite context is set.

## Example

*Illustrative* — calling the reporting function outside its event.

```sql
SELECT pg_event_trigger_table_rewrite_oid();
-- ERROR:  pg_event_trigger_table_rewrite_oid() can only be called in a table_rewrite event trigger function
```

## Related

- [cannot set generated column](./cannot-set-generated-column.md)
- [control reached end of trigger procedure without return](./control-reached-end-of-trigger-procedure-without-return.md)
