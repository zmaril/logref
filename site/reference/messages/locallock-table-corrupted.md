---
message: "locallock table corrupted"
slug: locallock-table-corrupted
passthrough: false
api: [elog]
level: [PANIC, WARNING]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:1514"
  - "postgres/src/backend/storage/lmgr/lock.c:2425"
reproduced: false
---

# `locallock table corrupted`

## What it means

Internal error. The backend's local lock table (its private record of locks it holds) is inconsistent. It is a consistency guard in the lock manager; at PANIC level it takes the process down to protect shared state.

## When it happens

It fires when the local lock bookkeeping does not match expectations during lock acquisition or release. Ordinary locking does not surface it; it points to memory corruption or an internal bug.

## How to fix

This is a can't-happen guard. After a PANIC the server restarts and recovers. Capture the workload leading up to it and report a reproducible case; investigate host memory if it recurs or coincides with other corruption.

## Example

*Illustrative* — an inconsistent local lock table.

```text
PANIC:  locallock table corrupted
```

## Related

- [lock on object is already held](./lock-on-object-is-already-held.md)
- [local buffer hash table corrupted](./local-buffer-hash-table-corrupted.md)
