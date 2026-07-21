---
message: "unexpected HeapTupleSatisfiesVacuum result"
slug: unexpected-heaptuplesatisfiesvacuum-result-a1d853
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pgstattuple/pgstatapprox.c:226"
  - "postgres/src/backend/access/heap/heapam_handler.c:835"
  - "postgres/src/backend/access/heap/heapam_handler.c:1112"
  - "postgres/src/backend/access/heap/heapam_handler.c:1578"
  - "postgres/src/backend/access/heap/pruneheap.c:1602"
  - "postgres/src/backend/access/heap/vacuumlazy.c:2288"
  - "postgres/src/backend/access/heap/vacuumlazy.c:3730"
reproduced: false
---

# `unexpected HeapTupleSatisfiesVacuum result`

## What it means

Internal error. During vacuum or a related scan, the visibility check `HeapTupleSatisfiesVacuum` returned a status the calling code does not handle. It is a consistency guard in the vacuum/pruning machinery reacting to a tuple state it did not expect.

## When it happens

Heap corruption, an unexpected combination of transaction-visibility flags on a tuple, or a bug in vacuum/pruning code. It can indicate damaged tuple headers. Healthy data does not produce it.

## How to fix

Suspect corruption of the affected table. Identify the relation, verify with `amcheck` (heapam checks) where available, and restore damaged data from a known-good backup. Check storage health. A reproducible case is valuable — capture the relation state and report it.

## Example

*Illustrative* — an unexpected visibility result during vacuum.

```text
ERROR:  unexpected HeapTupleSatisfiesVacuum result
```

## Related

- [unexpected table_tuple_lock status: %u](./unexpected-table-tuple-lock-status.md)
- [offnum out of range](./offnum-out-of-range.md)
