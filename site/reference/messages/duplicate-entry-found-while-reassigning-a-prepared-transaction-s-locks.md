---
message: "duplicate entry found while reassigning a prepared transaction's locks"
slug: duplicate-entry-found-while-reassigning-a-prepared-transaction-s-locks
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:3745"
reproduced: false
---

# `duplicate entry found while reassigning a prepared transaction's locks`

## What it means

An internal lock-manager guard hit during `PREPARE TRANSACTION`. While transferring the transaction's locks to the prepared-transaction owner, the code found a duplicate lock entry that should not exist. This is a severe "can't happen" check.

## When it happens

It fires while preparing a two-phase transaction, when the lock table is in an inconsistent state during lock reassignment. It points at an internal bug or memory/shared-state corruption.

## How to fix

This is not a user-facing condition, and at PANIC level it terminates the backend and restarts the server. Investigate for memory or shared-memory corruption and check hardware. Capture the log around the PANIC and the server version, and report a reproducible case to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
PANIC:  duplicate entry found while reassigning a prepared transaction's locks
```

## Related

- [dynamic shared memory control segment is not valid](./dynamic-shared-memory-control-segment-is-not-valid.md)
- [entry ref vanished before deletion](./entry-ref-vanished-before-deletion.md)
