---
message: "invalid max offset number"
slug: invalid-max-offset-number
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/heap/heapam_xlog.c:429"
  - "postgres/src/backend/access/heap/heapam_xlog.c:576"
  - "postgres/src/backend/access/heap/heapam_xlog.c:856"
reproduced: false
---

# `invalid max offset number`

## What it means

Internal error during WAL replay. A heap redo record described a page whose maximum item-offset number is not valid. Because it surfaces in the recovery path, it is raised at PANIC and stops the server rather than risk applying an inconsistent change.

## When it happens

It should not occur during normal replay of records written by a healthy primary. Reaching it points to a corrupt or truncated WAL record, damaged storage on the standby, or a serious internal inconsistency.

## How to fix

Treat it as a recovery-integrity emergency. Preserve the data directory and WAL, check storage and memory health on the affected server, and recover from a known-good base backup plus intact WAL. Capture the surrounding log context and report it, since a PANIC in replay is not expected.

## Example

*Illustrative* — raised while replaying a heap record.

```text
PANIC:  invalid max offset number
```

## Related

- [invalid index offnum](./invalid-index-offnum.md)
- [lock table corrupted](./lock-table-corrupted.md)
