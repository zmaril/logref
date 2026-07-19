---
message: "block to be initialized in redo routine must be marked with WILL_INIT flag in the WAL record"
slug: block-to-be-initialized-in-redo-routine-must-be-marked-with-will-init-flag-in
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/xlogutils.c:393"
reproduced: false
---

# `block to be initialized in redo routine must be marked with WILL_INIT flag in the WAL record`

## What it means

During WAL replay a redo routine was about to initialize a page from scratch, but the WAL record did not set the WILL_INIT flag that promises this. The flag and the action must agree, and this mismatch is a fatal replay inconsistency.

## When it happens

It is an internal recovery guard. It can appear during crash recovery or on a standby if the WAL stream is inconsistent with the redo logic, which points at corruption or a version mismatch.

## How to fix

This is not user-fixable at replay time. Investigate the WAL source and versions: ensure primary and standby run compatible builds, check for WAL corruption, and if recovery cannot proceed, restore from backup. Report it if builds match and WAL is intact.

## Example

*Illustrative* — the redo-flag guard.

```text
PANIC:  block to be initialized in redo routine must be marked with WILL_INIT flag in the WAL record
```

## Related

- [block with will_init flag in wal record must be zeroed by redo routine](./block-with-will-init-flag-in-wal-record-must-be-zeroed-by-redo-routine.md)
- [btree_redo unknown op code](./btree-redo-unknown-op-code.md)
