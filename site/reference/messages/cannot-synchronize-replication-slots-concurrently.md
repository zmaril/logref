---
message: "cannot synchronize replication slots concurrently"
slug: cannot-synchronize-replication-slots-concurrently
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:1526"
reproduced: false
---

# `cannot synchronize replication slots concurrently`

## What it means

Two attempts to synchronize replication slots ran at the same time. Slot synchronization is single-threaded on a standby, so a second concurrent run is rejected while one is already in progress.

## When it happens

It occurs when `pg_sync_replication_slots()` is called while the slot-sync worker is running, or while another manual synchronization is already underway.

## How to fix

Wait for the in-progress synchronization to finish before starting another. If the slot-sync worker is active, rely on it rather than calling the function manually.

## Example

*Illustrative* — overlapping sync calls.

```text
ERROR:  cannot synchronize replication slots concurrently
```

## Related

- [cannot synchronize local slot](./cannot-synchronize-local-slot.md)
- [cannot synchronize replication slots from a standby server](./cannot-synchronize-replication-slots-from-a-standby-server.md)
