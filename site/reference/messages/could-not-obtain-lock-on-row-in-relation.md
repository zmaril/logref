---
message: "could not obtain lock on row in relation \"%s\""
slug: could-not-obtain-lock-on-row-in-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_LOCK_NOT_AVAILABLE
    code: "55P03"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:4955"
  - "postgres/src/backend/access/heap/heapam.c:4993"
  - "postgres/src/backend/access/heap/heapam.c:5260"
  - "postgres/src/backend/access/heap/heapam_handler.c:371"
reproduced: true
---

# `could not obtain lock on row in relation "%s"`

## What it means

A row-level lock could not be taken immediately and the statement was told not to wait. The placeholder is the relation name. This is the `NOWAIT` outcome: the row is locked by another transaction, and because waiting was disallowed, the statement fails instead of blocking.

## When it happens

Running `SELECT ... FOR UPDATE/SHARE NOWAIT` (or an `UPDATE`/`DELETE` under a lock-if-available path) against rows another transaction currently holds locked.

## How to fix

Retry after the conflicting transaction releases the lock, or drop `NOWAIT` to wait for it (optionally with `SKIP LOCKED` to ignore locked rows instead). Reduce lock contention by shortening transactions that hold row locks. Treat this as expected under `NOWAIT` and handle it in application logic.

## Example

*Reproduced* — this site fired under `reproducers/scenarios/50_txn_concurrency.sh`; see the reproducer for the triggering workload. It emits:

```text
ERROR:  could not obtain lock on row in relation "%s"
```

## Related

- [you don't own a lock of type](./you-don-t-own-a-lock-of-type.md)
- [permission denied to terminate process](./permission-denied-to-terminate-process.md)
