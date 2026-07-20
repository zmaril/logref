---
message: "replication origin with ID %d is already active for PID %d"
slug: replication-origin-with-id-is-already-active-for-pid
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_IN_USE
    code: "55006"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:982"
  - "postgres/src/backend/replication/logical/origin.c:1203"
reproduced: false
---

# `replication origin with ID %d is already active for PID %d`

## What it means

A process tried to acquire a replication origin that another process already has active. The placeholders are the origin id and the PID currently holding it. A replication origin can be claimed by only one session at a time.

## When it happens

It arises when a logical replication apply worker (or a manual `pg_replication_origin_session_setup`) tries to attach an origin that is already in use — for example a duplicate worker, or a manual call while apply is running.

## How to fix

Do not attach the origin from two places at once. If a stale holder exists, identify the PID reported and stop it; if it is an apply worker, manage it through the subscription rather than manual origin calls.

## Example

*Illustrative* — attaching a replication origin already held elsewhere.

```text
ERROR:  replication origin with ID 2 is already active for PID 41500
```

## Related

- [replication slot "%s" is active for PID %d](./replication-slot-is-active-for-pid.md)
- [replication slot "%s" was not created in this database](./replication-slot-was-not-created-in-this-database.md)
