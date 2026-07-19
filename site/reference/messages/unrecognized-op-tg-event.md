---
message: "unrecognized OP tg_event: %u"
slug: unrecognized-op-tg-event
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_exec.c:932"
  - "postgres/src/pl/plpython/plpy_exec.c:959"
  - "postgres/src/pl/tcl/pltcl.c:1222"
  - "postgres/src/pl/tcl/pltcl.c:1242"
reproduced: false
---

# `unrecognized OP tg_event: %u`

## What it means

Internal error. Trigger-support code (here PL/Python) received a trigger-event code it does not recognize when reporting which operation fired the trigger. The placeholder is the event value. The event should always be one of insert/update/delete/truncate, so an unrecognized value is a consistency guard.

## When it happens

It does not arise from ordinary trigger use. It points to an internal inconsistency in the trigger machinery or the procedural-language handler rather than to the trigger function's own code.

## How to fix

Treat it as an internal bug. If it correlates with a specific procedural-language version or extension, suspect that module and confirm it matches the server version. Capture the trigger definition and report it.

## Example

*Illustrative* — emitted internally by a PL trigger handler.

```text
ERROR:  unrecognized OP tg_event: 42
```

## Related

- [unrecognized table_tuple_lock status](./unrecognized-table-tuple-lock-status.md)
- [has no attribute](./has-no-attribute.md)
