---
message: "brin_xlog_samepage_update: failed to replace tuple"
slug: brin-xlog-samepage-update-failed-to-replace-tuple
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/brin/brin_xlog.c:193"
reproduced: false
---

# `brin_xlog_samepage_update: failed to replace tuple`

## What it means

While replaying a BRIN same-page update WAL record, the redo routine could not replace the existing tuple on the page. Replay must reproduce the original in-place update, so a failed replace is a fatal inconsistency.

## When it happens

It occurs during crash recovery or on a standby when a BRIN page does not match the WAL, typically from corruption.

## How to fix

This is not user-fixable at replay time. Investigate storage and version compatibility, check for corruption, and restore from backup if recovery cannot proceed. Rebuild the BRIN index with `REINDEX` once the server is up.

## Example

*Illustrative* — a failed BRIN same-page replace.

```text
PANIC:  brin_xlog_samepage_update: failed to replace tuple
```

## Related

- [brin_xlog_insert_update failed to add tuple](./brin-xlog-insert-update-failed-to-add-tuple.md)
- [brin_redo unknown op code](./brin-redo-unknown-op-code.md)
