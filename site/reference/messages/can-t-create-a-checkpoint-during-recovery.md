---
message: "can't create a checkpoint during recovery"
slug: can-t-create-a-checkpoint-during-recovery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:7425"
reproduced: false
---

# `can't create a checkpoint during recovery`

## What it means

Internal code requested a full checkpoint while the server is in recovery. During recovery the server produces restartpoints rather than checkpoints, so a checkpoint request here is invalid. It is an internal guard.

## When it happens

It is a can't-happen check in the checkpoint machinery. Ordinary `CHECKPOINT` on a standby is turned into a restartpoint and does not reach this guard.

## How to fix

There is no user action for normal operation. If it appears, capture the surrounding log and any extension that triggers checkpoints, and report it as a possible bug with the server version.

## Example

*Illustrative* — a checkpoint requested in recovery.

```text
ERROR:  can't create a checkpoint during recovery
```

## Related

- [can only be used at end of recovery](./can-only-be-used-at-end-of-recovery.md)
- [cannot abort during a parallel operation](./cannot-abort-during-a-parallel-operation.md)
