---
message: "unrecognized event type: %d"
slug: unrecognized-event-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:3290"
  - "postgres/src/backend/parser/parse_utilcmd.c:3437"
reproduced: false
---

# `unrecognized event type: %d`

## What it means

Internal error. Event-handling code (event triggers or a similar dispatcher) met an event-type value outside the set it recognizes.

## When it happens

It fires where an event kind is switched on and the value does not match a known case. Normal operation does not produce it.

## How to fix

This is an internal guard. If routine event-trigger activity reaches it, capture the trigger definition and the command involved and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized event type.

```text
ERROR:  unrecognized event type: 9
```

## Related

- [unrecognized LEVEL tg_event: %u](./unrecognized-level-tg-event.md)
- [unrecognized WHEN tg_event: %u](./unrecognized-when-tg-event.md)
