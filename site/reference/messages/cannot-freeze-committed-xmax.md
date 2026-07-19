---
message: "cannot freeze committed xmax %u"
slug: cannot-freeze-committed-xmax
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:7344"
reproduced: false
---

# `cannot freeze committed xmax %u`

## What it means

A corruption guard in the heap freezing code fired: `VACUUM` found a tuple whose `xmax` (the transaction that deleted or locked it) is marked committed but is being asked to freeze. Freezing a committed delete marker would erase a valid row version, so Postgres refuses and reports data corruption. The placeholder is the transaction id.

## When it happens

It is reached during aggressive or wraparound `VACUUM` when a heap page holds inconsistent visibility bits — typically the sign of on-disk corruption from hardware faults, a bad restore, or a storage-layer bug.

## How to fix

Treat it as possible data corruption. Stop writes to the affected table, take a physical backup, and inspect the block. Identify the damaged tuple, restore the table from a known-good backup where possible, and investigate the storage stack. Report the finding with the block details if no external cause is found.

## Example

*Illustrative* — an inconsistent xmax during freeze.

```text
ERROR:  cannot freeze committed xmax 574839
```

## Related

- [cannot look at latest visible tid for relation](./cannot-look-at-latest-visible-tid-for-relation.md)
- [cannot insert oversize tuple of size on internal page of index](./cannot-insert-oversized-tuple-of-size-on-internal-page-of-index.md)
