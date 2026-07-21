---
message: "invalid after-trigger event code: %d"
slug: invalid-after-trigger-event-code
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/trigger.c:5705"
  - "postgres/src/backend/commands/trigger.c:6453"
reproduced: false
---

# `invalid after-trigger event code: %d`

## What it means

Internal error. The after-trigger event queue held an entry whose event-type bits do not correspond to any known trigger event. It is a consistency guard over the deferred-trigger machinery.

## When it happens

It fires while firing deferred (AFTER) triggers at statement or transaction end when a queued event's code is unrecognized. Ordinary trigger use does not surface it; it points to memory corruption or an internal bug.

## How to fix

This is a can't-happen guard. Capture the statements and triggers involved and report a reproducible case. If it appears alongside other corruption or crash symptoms, investigate the server host's memory and storage.

## Example

*Illustrative* — a corrupt entry in the after-trigger queue.

```text
ERROR:  invalid after-trigger event code: 99
```

## Related

- [invalid tgkind passed to ri_set](./invalid-tgkind-passed-to-ri-set.md)
- [invalid pruning combine step argument](./invalid-pruning-combine-step-argument.md)
