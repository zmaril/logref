---
message: "brin_xlog_insert_update: failed to add tuple"
slug: brin-xlog-insert-update-failed-to-add-tuple
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/brin/brin_xlog.c:92"
reproduced: false
---

# `brin_xlog_insert_update: failed to add tuple`

## What it means

While replaying a BRIN insert-or-update WAL record, the redo routine could not place the tuple on its target page. Replay must reproduce the original change, so a failed add is a fatal inconsistency between the WAL and the page.

## When it happens

It occurs during crash recovery or on a standby when a BRIN index page is inconsistent with the WAL, typically from corruption.

## How to fix

This is not user-fixable at replay time. Investigate storage and versions, check for WAL or page corruption, and restore from backup if recovery is blocked. The affected BRIN index can be rebuilt with `REINDEX` once the server is running.

## Example

*Illustrative* — a failed BRIN redo add.

```text
PANIC:  brin_xlog_insert_update: failed to add tuple
```

## Related

- [brin_xlog_insert_update invalid max offset number](./brin-xlog-insert-update-invalid-max-offset-number.md)
- [brin_xlog_samepage_update failed to replace tuple](./brin-xlog-samepage-update-failed-to-replace-tuple.md)
