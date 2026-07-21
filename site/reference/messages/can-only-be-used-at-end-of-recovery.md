---
message: "can only be used at end of recovery"
slug: can-only-be-used-at-end-of-recovery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:7989"
reproduced: false
---

# `can only be used at end of recovery`

## What it means

An operation that is only valid at the moment recovery finishes was invoked at another time. It applies to a specific recovery-completion step and has no meaning outside that window.

## When it happens

It is an internal timing guard around the end-of-recovery transition. It does not arise from ordinary SQL and points at a subsystem or extension using a recovery hook at the wrong moment.

## How to fix

There is no user action for normal operation. If it appears, note any extension that participates in recovery or startup and capture the surrounding log, then report it with the server version.

## Example

*Illustrative* — the recovery-timing guard.

```text
ERROR:  can only be used at end of recovery
```

## Related

- [can only be used to end recovery](./can-only-be-used-to-end-recovery.md)
- [can't create a checkpoint during recovery](./can-t-create-a-checkpoint-during-recovery.md)
