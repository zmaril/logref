---
message: "brin_redo: unknown op code %u"
slug: brin-redo-unknown-op-code
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/brin/brin_xlog.c:334"
reproduced: false
---

# `brin_redo: unknown op code %u`

## What it means

During WAL replay the BRIN redo handler read a record whose operation code it does not recognize. The placeholder is the code. Each WAL record type maps to a known BRIN operation, and an unknown one cannot be replayed. It is a fatal recovery condition.

## When it happens

It occurs during crash recovery or on a standby when the WAL stream is corrupted or was written by an incompatible version.

## How to fix

This is not user-fixable at replay time. Confirm primary and standby run compatible builds, check for WAL corruption, and restore from backup if recovery cannot continue. Report it if versions match and the WAL is intact.

## Example

*Illustrative* — an unknown BRIN opcode in WAL.

```text
PANIC:  brin_redo: unknown op code 42
```

## Related

- [btree_redo unknown op code](./btree-redo-unknown-op-code.md)
- [brin_xlog_insert_update failed to add tuple](./brin-xlog-insert-update-failed-to-add-tuple.md)
