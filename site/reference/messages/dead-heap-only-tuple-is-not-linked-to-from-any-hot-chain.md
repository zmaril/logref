---
message: "dead heap-only tuple (%u, %d) is not linked to from any HOT chain"
slug: dead-heap-only-tuple-is-not-linked-to-from-any-hot-chain
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/pruneheap.c:696"
reproduced: false
---

# `dead heap-only tuple (%u, %d) is not linked to from any HOT chain`

## What it means

During heap pruning the server found a dead heap-only tuple that no HOT chain points to. The placeholders are the block and offset. Heap-only tuples are supposed to be reachable through a HOT update chain; an orphaned one is a consistency problem.

## When it happens

It fires while vacuum or on-access pruning walks a page and finds a heap-only tuple that is not linked from any chain, which points at heap corruption rather than normal operation.

## How to fix

This is a consistency guard that usually signals corruption. Preserve the server log and investigate the storage under the affected relation for I/O errors or a past unclean crash. Verify the table with `amcheck`'s heap checks, and consider restoring the affected table from a known-good backup if corruption is confirmed.

## Example

*Illustrative* — an orphaned heap-only tuple.

```text
ERROR:  dead heap-only tuple (5, 12) is not linked to from any HOT chain
```

## Related

- [cross page item order invariant violated for index](./cross-page-item-order-invariant-violated-for-index.md)
- [could not read WAL record](./could-not-read-wal-record.md)
