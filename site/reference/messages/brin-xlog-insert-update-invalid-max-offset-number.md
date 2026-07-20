---
message: "brin_xlog_insert_update: invalid max offset number"
slug: brin-xlog-insert-update-invalid-max-offset-number
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/brin/brin_xlog.c:88"
reproduced: false
---

# `brin_xlog_insert_update: invalid max offset number`

## What it means

While replaying a BRIN insert-or-update WAL record, the redo routine found a maximum offset number on the target page that is inconsistent with the record. Replay cannot proceed against a page that does not match the WAL. It is a fatal recovery condition.

## When it happens

It occurs during crash recovery or on a standby when a BRIN page and the WAL disagree, usually from corruption.

## How to fix

This is not user-fixable at replay time. Check storage, hardware, and version compatibility, look for WAL or page corruption, and restore from backup if recovery is stuck. Rebuild the BRIN index with `REINDEX` once running.

## Example

*Illustrative* — a bad max offset during BRIN redo.

```text
PANIC:  brin_xlog_insert_update: invalid max offset number
```

## Related

- [brin_xlog_insert_update failed to add tuple](./brin-xlog-insert-update-failed-to-add-tuple.md)
- [brin_xlog_samepage_update failed to replace tuple](./brin-xlog-samepage-update-failed-to-replace-tuple.md)
