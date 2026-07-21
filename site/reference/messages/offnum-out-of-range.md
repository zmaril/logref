---
message: "offnum out of range"
slug: offnum-out-of-range
passthrough: false
api: [elog]
level: [ERROR, PANIC]
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:6077"
  - "postgres/src/backend/access/heap/heapam_xlog.c:326"
  - "postgres/src/backend/access/heap/heapam_xlog.c:775"
  - "postgres/src/backend/access/heap/heapam_xlog.c:992"
  - "postgres/src/backend/access/heap/heapam_xlog.c:1052"
  - "postgres/src/backend/access/heap/heapam_xlog.c:1128"
  - "postgres/src/backend/access/heap/heapam_xlog.c:1172"
  - "postgres/src/backend/access/nbtree/nbtsearch.c:2153"
reproduced: false
---

# `offnum out of range`

## What it means

Internal error. Code accessing a heap or index page was given an item offset number (`OffsetNumber`) outside the valid range for that page. The offset identifies a line pointer within a page; a value past the page's item count indicates an inconsistency or corruption.

## When it happens

Heap or index page corruption, a bug in code that manipulates page line pointers, or replay of a WAL record referencing a bad offset. It can reach `PANIC` during recovery. Ordinary queries do not produce it on healthy data.

## How to fix

Suspect corruption. Identify the affected relation/page, verify with `amcheck` (for indexes) or by inspecting the heap page, and restore the affected data from a known-good backup if it is damaged. During recovery a `PANIC` here points at a corrupt WAL record or page — investigate storage health. Report reproducible cases.

## Example

*Illustrative* — a corrupt page offset during access.

```text
ERROR:  offnum out of range
```

## Related

- [corrupted page pointers: lower = %u, upper = %u, special = %u](./corrupted-page-pointers-lower-upper-special.md)
- [invalid lp](./invalid-lp.md)
