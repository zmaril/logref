---
message: "invalid lp"
slug: invalid-lp
passthrough: false
api: [elog]
level: [ERROR, PANIC]
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:6080"
  - "postgres/src/backend/access/heap/heapam_xlog.c:329"
  - "postgres/src/backend/access/heap/heapam_xlog.c:778"
  - "postgres/src/backend/access/heap/heapam_xlog.c:995"
  - "postgres/src/backend/access/heap/heapam_xlog.c:1055"
  - "postgres/src/backend/access/heap/heapam_xlog.c:1131"
  - "postgres/src/backend/access/heap/heapam_xlog.c:1175"
reproduced: false
---

# `invalid lp`

## What it means

Internal error. Code examining a heap line pointer (the small "item pointer" that locates a tuple within a page) found it in an invalid state — its flags/length combination is not one a valid line pointer can have. It is a corruption guard in the heap access code.

## When it happens

Heap page corruption, a bug in heap or WAL-replay code, or failing storage that damaged a page. It can reach `PANIC` during recovery when replaying a record against a corrupt page. Healthy data does not produce it.

## How to fix

Suspect corruption. Identify the affected relation and page, and restore the damaged data from a known-good backup. Verify storage health (a bad line pointer often accompanies hardware faults). During recovery a `PANIC` here indicates a corrupt page or WAL record — investigate the disk and consider restoring. Report reproducible cases.

## Example

*Illustrative* — a corrupt heap line pointer during access.

```text
ERROR:  invalid lp
```

## Related

- [offnum out of range](./offnum-out-of-range.md)
- [corrupted page pointers: lower = %u, upper = %u, special = %u](./corrupted-page-pointers-lower-upper-special.md)
