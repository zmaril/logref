---
message: "block with WILL_INIT flag in WAL record must be zeroed by redo routine"
slug: block-with-will-init-flag-in-wal-record-must-be-zeroed-by-redo-routine
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/xlogutils.c:391"
reproduced: false
---

# `block with WILL_INIT flag in WAL record must be zeroed by redo routine`

## What it means

During WAL replay a record set the WILL_INIT flag, promising the redo routine would initialize the page from empty, but the routine did not zero it as required. The flag and the redo action disagree, which is a fatal replay inconsistency.

## When it happens

It is an internal recovery guard that can appear during crash recovery or on a standby when WAL and redo logic are inconsistent, suggesting corruption or a version mismatch.

## How to fix

This is not user-fixable at replay time. Confirm primary and standby run compatible versions, check for WAL corruption, and restore from backup if recovery is stuck. Report it if versions match and the WAL is sound.

## Example

*Illustrative* — the redo-zeroing guard.

```text
PANIC:  block with WILL_INIT flag in WAL record must be zeroed by redo routine
```

## Related

- [block to be initialized in redo routine must be marked with will_init flag](./block-to-be-initialized-in-redo-routine-must-be-marked-with-will-init-flag-in.md)
- [brin_redo unknown op code](./brin-redo-unknown-op-code.md)
