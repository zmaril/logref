---
message: "btree_redo: unknown op code %u"
slug: btree-redo-unknown-op-code
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtxlog.c:1056"
reproduced: false
---

# `btree_redo: unknown op code %u`

## What it means

During WAL replay the B-tree redo handler read a record whose operation code it does not recognize. The placeholder is the code. Each B-tree WAL record maps to a known operation, and an unknown one cannot be replayed. It is a fatal recovery condition.

## When it happens

It occurs during crash recovery or on a standby when the WAL stream is corrupted or was written by an incompatible version.

## How to fix

This is not user-fixable at replay time. Confirm primary and standby run compatible builds, check for WAL corruption, and restore from backup if recovery cannot continue. Report it if versions match and the WAL is sound.

## Example

*Illustrative* — an unknown B-tree opcode in WAL.

```text
PANIC:  btree_redo: unknown op code 99
```

## Related

- [brin_redo unknown op code](./brin-redo-unknown-op-code.md)
- [bt_restore_page cannot add item to page](./bt-restore-page-cannot-add-item-to-page.md)
