---
message: "can only be used to end recovery"
slug: can-only-be-used-to-end-recovery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:7915"
reproduced: false
---

# `can only be used to end recovery`

## What it means

A recovery-control operation that exists only to conclude recovery was invoked for another purpose or at another time. It applies to the specific action that ends recovery.

## When it happens

It is an internal timing guard around recovery completion. It does not arise from ordinary SQL and points at a subsystem or extension driving recovery control incorrectly.

## How to fix

There is no user action for normal operation. If it appears, note any recovery-related extension and capture the surrounding log, then report it with the server version.

## Example

*Illustrative* — the recovery-control guard.

```text
ERROR:  can only be used to end recovery
```

## Related

- [can only be used at end of recovery](./can-only-be-used-at-end-of-recovery.md)
- [can't create a checkpoint during recovery](./can-t-create-a-checkpoint-during-recovery.md)
