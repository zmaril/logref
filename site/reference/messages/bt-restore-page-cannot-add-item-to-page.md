---
message: "_bt_restore_page: cannot add item to page"
slug: bt-restore-page-cannot-add-item-to-page
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtxlog.c:75"
reproduced: false
---

# `_bt_restore_page: cannot add item to page`

## What it means

While replaying a B-tree WAL record that restores a page's contents, the redo routine could not add an item to the page. Replay must rebuild the page exactly, so a failed add is a fatal inconsistency between the WAL and the page state.

## When it happens

It occurs during crash recovery or on a standby when a B-tree page and the WAL disagree, usually from corruption.

## How to fix

This is not user-fixable at replay time. Check storage, hardware, and version compatibility, look for WAL or page corruption, and restore from backup if recovery is blocked. Rebuild the affected index with `REINDEX` once running.

## Example

*Illustrative* — a failed B-tree page restore.

```text
PANIC:  _bt_restore_page: cannot add item to page
```

## Related

- [btree_redo unknown op code](./btree-redo-unknown-op-code.md)
- [brin_xlog_insert_update failed to add tuple](./brin-xlog-insert-update-failed-to-add-tuple.md)
