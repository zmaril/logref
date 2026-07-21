---
message: "out of shared memory"
slug: out-of-shared-memory
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OUT_OF_MEMORY
    code: "53200"
call_sites:
  - "postgres/src/backend/storage/ipc/shm_toc.c:115"
  - "postgres/src/backend/storage/ipc/shm_toc.c:202"
  - "postgres/src/backend/storage/lmgr/lock.c:1048"
  - "postgres/src/backend/storage/lmgr/lock.c:1086"
  - "postgres/src/backend/storage/lmgr/lock.c:3006"
  - "postgres/src/backend/storage/lmgr/lock.c:4383"
  - "postgres/src/backend/storage/lmgr/lock.c:4448"
  - "postgres/src/backend/storage/lmgr/lock.c:4798"
  - "postgres/src/backend/storage/lmgr/predicate.c:2405"
  - "postgres/src/backend/storage/lmgr/predicate.c:2420"
  - "postgres/src/backend/storage/lmgr/predicate.c:3817"
  - "postgres/src/backend/storage/lmgr/predicate.c:4865"
  - "postgres/src/backend/utils/hash/dynahash.c:1025"
reproduced: false
---

# `out of shared memory`

## What it means

A request for space in a shared-memory area failed — a fixed-size shared structure is full. Unlike ordinary `out of memory` (per-backend heap), this is one of the cluster-wide pools sized at startup, such as the lock table or the predicate-lock table.

## When it happens

Running out of lock-table slots (too many locks held at once — many partitions, many objects touched in one transaction), exhausting the predicate-lock area under `SERIALIZABLE`, or too many concurrent operations for a shared pool. The hint usually names the parameter to raise.

## How to fix

Read the hint — it names the limit. Commonly raise `max_locks_per_transaction` (which sizes the shared lock table) when transactions touch very many objects, or `max_pred_locks_per_transaction` for serializable workloads. These require a restart. Also reconsider transactions that lock enormous numbers of objects at once, which may be the real problem.

## Example

*Illustrative* — exhausting the lock table.

```text
ERROR:  out of shared memory
HINT:  You might need to increase "max_locks_per_transaction".
```

## Related

- [out of memory](./out-of-memory-6bf5c2.md)
- [sorry, too many clients already](./sorry-too-many-clients-already.md)
