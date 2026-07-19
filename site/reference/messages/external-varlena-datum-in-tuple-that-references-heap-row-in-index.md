---
message: "external varlena datum in tuple that references heap row (%u,%u) in index \"%s\""
slug: external-varlena-datum-in-tuple-that-references-heap-row-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:2887"
reproduced: false
---

# `external varlena datum in tuple that references heap row (%u,%u) in index "%s"`

## What it means

An `amcheck` corruption report. Verifying a B-tree index, it found an index tuple whose stored value is an external (out-of-line TOAST) datum, which should never appear inside an index tuple that points at a heap row. The placeholders are the heap block and offset and the index name.

## When it happens

It fires from `amcheck` B-tree verification (`bt_index_check`, `bt_index_parent_check`) when index data is inconsistent — a real sign of index corruption, often following storage faults, a crash with damaged data, or a software defect.

## How to fix

Treat this as index corruption. Rebuild the index with `REINDEX INDEX indexname` (or `REINDEX INDEX CONCURRENTLY`). Then investigate the underlying cause — check storage health, review recent crashes, and verify other indexes and the heap. If corruption is widespread, restore from a known-good backup and check the hardware.

## Example

*Illustrative* — the message as logged.

```
ERROR:  external varlena datum in tuple that references heap row (42,7) in index "orders_idx"
```

## Related

- [expected index as targets for verification](./expected-index-as-targets-for-verification-e91a5a.md)
- [failed to add high key to the index page](./failed-to-add-high-key-to-the-index-page.md)
