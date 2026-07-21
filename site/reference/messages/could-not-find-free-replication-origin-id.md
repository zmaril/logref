---
message: "could not find free replication origin ID"
slug: could-not-find-free-replication-origin-id
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:374"
reproduced: false
---

# `could not find free replication origin ID`

## What it means

The server ran out of free replication-origin identifiers when trying to create a new one. Every configured origin slot is in use, so no ID could be assigned.

## When it happens

It happens when creating a replication origin (directly or as part of adding a subscription) while the number of existing origins has reached the configured maximum.

## How to fix

Raise `max_replication_slots` (which also bounds replication origins) and restart, or drop replication origins that are no longer needed. Check `pg_replication_origin` for stale entries left by removed subscriptions.

## Example

*Illustrative* — no free origin ID available.

```text
ERROR:  could not find free replication origin ID
```

## Related

- [could not find free replication state, increase max_active_replication_origins](./could-not-find-free-replication-state-increase-max-active-replication-origins.md)
- [could not drop replication origin with ID, in use by PID](./could-not-drop-replication-origin-with-id-in-use-by-pid.md)
