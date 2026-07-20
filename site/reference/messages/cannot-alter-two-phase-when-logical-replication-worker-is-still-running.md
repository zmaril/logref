---
message: "cannot alter \"two_phase\" when logical replication worker is still running"
slug: cannot-alter-two-phase-when-logical-replication-worker-is-still-running
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:1838"
reproduced: false
---

# `cannot alter "two_phase" when logical replication worker is still running`

## What it means

An `ALTER SUBSCRIPTION` tried to change the `two_phase` option while the subscription's logical-replication worker is still running. Two-phase commit handling cannot be reconfigured under an active worker.

## When it happens

It occurs when altering `two_phase` on a subscription whose apply worker has not stopped.

## How to fix

Disable the subscription with `ALTER SUBSCRIPTION name DISABLE`, wait for the apply worker to exit, change `two_phase`, then re-enable it. The option can only be changed while no worker is active.

## Example

*Illustrative* — changing two_phase with a live worker.

```sql
ALTER SUBSCRIPTION s SET (two_phase = on);
```

## Related

- [cannot alter retain_dead_tuples when logical replication worker is still running](./cannot-alter-retain-dead-tuples-when-logical-replication-worker-is-still-running.md)
- [cannot add schema to publication](./cannot-add-schema-to-publication-84c13e.md)
