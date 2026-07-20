---
message: "unrecognized LEVEL tg_event: %u"
slug: unrecognized-level-tg-event
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_exec.c:967"
  - "postgres/src/pl/tcl/pltcl.c:1250"
reproduced: false
---

# `unrecognized LEVEL tg_event: %u`

## What it means

Internal error. Trigger-firing code building the `TG_LEVEL` value for a trigger function met a level code that is neither the row nor statement case.

## When it happens

It fires where a trigger's level is encoded and the value is outside the known set. A normally defined trigger does not produce it.

## How to fix

This is an internal guard in the trigger machinery. If a real trigger fires it, capture the trigger definition and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized trigger level.

```text
ERROR:  unrecognized LEVEL tg_event: 4
```

## Related

- [unrecognized WHEN tg_event: %u](./unrecognized-when-tg-event.md)
- [unexpected return value from trigger procedure](./unexpected-return-value-from-trigger-procedure.md)
