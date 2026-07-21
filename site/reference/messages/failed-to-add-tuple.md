---
message: "failed to add tuple"
slug: failed-to-add-tuple
passthrough: false
api: [elog]
level: [ERROR, PANIC]
call_sites:
  - "postgres/src/backend/access/heap/heapam_xlog.c:453"
  - "postgres/src/backend/access/heap/heapam_xlog.c:602"
  - "postgres/src/backend/access/heap/heapam_xlog.c:934"
  - "postgres/src/backend/access/heap/rewriteheap.c:682"
reproduced: false
---

# `failed to add tuple`

## What it means

Internal error. During WAL replay (or a heap insert path), the code tried to place a tuple onto a page that should have had room for it and the insertion failed. At `PANIC` during recovery this aborts the server, because replay must be able to reproduce the recorded change exactly.

## When it happens

It should not occur in correct operation. During recovery it usually signals that the page state on the standby/recovering server does not match what the WAL record assumes — a sign of corruption, a torn page, or a replay inconsistency.

## How to fix

Treat it as serious: at `PANIC` the server has stopped. Investigate storage integrity on the affected relation, and check whether the base backup or the WAL source is damaged. This often means restoring from a known-good backup. Capture the logs (the WAL record and block) and report it if the cause is unclear.

## Example

*Illustrative* — emitted internally during WAL replay.

```text
PANIC:  failed to add tuple
```

## Related

- [index contains unexpected zero page at block](./index-contains-unexpected-zero-page-at-block.md)
- [invalid data in file](./invalid-data-in-file.md)
