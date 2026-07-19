---
message: "lock %s on object %u/%u/%u is already held"
slug: lock-on-object-is-already-held
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:1455"
  - "postgres/src/backend/storage/lmgr/lock.c:4487"
reproduced: false
---

# `lock %s on object %u/%u/%u is already held`

## What it means

Internal error. Lock-manager code tried to record a lock that its bookkeeping says is already held in a way that should not repeat. The placeholders identify the lock mode and object. It is a consistency guard in the lock manager.

## When it happens

It fires when the lock accounting reaches an inconsistent state during acquisition. Ordinary locking, including normal re-locking, does not surface it; it points to an internal inconsistency.

## How to fix

This is a can't-happen guard. Capture the concurrent workload and report a reproducible case. If it recurs or comes with other anomalies, investigate the host for memory problems.

## Example

*Illustrative* — a lock the accounting already records as held.

```text
ERROR:  lock ShareLock on object 16384/16390/0 is already held
```

## Related

- [locallock table corrupted](./locallock-table-corrupted.md)
- [local buffer hash table corrupted](./local-buffer-hash-table-corrupted.md)
