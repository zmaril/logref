---
message: "unrecognized WHEN tg_event: %u"
slug: unrecognized-when-tg-event
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_exec.c:869"
  - "postgres/src/pl/tcl/pltcl.c:1164"
reproduced: false
---

# `unrecognized WHEN tg_event: %u`

## What it means

Internal error. Trigger-firing code building the `TG_WHEN` value for a trigger function met a timing code that is not the before, after, or instead-of case.

## When it happens

It fires where a trigger's timing is encoded and the value is outside the known set. A normally defined trigger does not produce it.

## How to fix

This is an internal guard in the trigger machinery. If a real trigger fires it, capture the trigger definition and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized trigger timing.

```text
ERROR:  unrecognized WHEN tg_event: 8
```

## Related

- [unrecognized LEVEL tg_event: %u](./unrecognized-level-tg-event.md)
- [unexpected return value from trigger procedure](./unexpected-return-value-from-trigger-procedure.md)
