---
message: "cannot alter retain_dead_tuples when logical replication worker is still running"
slug: cannot-alter-retain-dead-tuples-when-logical-replication-worker-is-still-running
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:1922"
reproduced: false
---

# `cannot alter retain_dead_tuples when logical replication worker is still running`

## What it means

An `ALTER SUBSCRIPTION` tried to change the `retain_dead_tuples` option while the subscription's logical-replication worker is still running. This option cannot be changed under an active worker.

## When it happens

It occurs when altering `retain_dead_tuples` on a subscription whose apply worker has not stopped.

## How to fix

Disable the subscription first with `ALTER SUBSCRIPTION name DISABLE`, wait for the apply worker to exit, change `retain_dead_tuples`, then re-enable it. The option can only be changed while no worker is active.

## Example

*Illustrative* — changing the option with a live worker.

```sql
ALTER SUBSCRIPTION s SET (retain_dead_tuples = false);
```

## Related

- [cannot alter two_phase when logical replication worker is still running](./cannot-alter-two-phase-when-logical-replication-worker-is-still-running.md)
- [cannot alter replication slot](./cannot-alter-replication-slot.md)
