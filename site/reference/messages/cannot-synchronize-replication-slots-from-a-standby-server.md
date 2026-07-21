---
message: "cannot synchronize replication slots from a standby server"
slug: cannot-synchronize-replication-slots-from-a-standby-server
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:1143"
reproduced: false
---

# `cannot synchronize replication slots from a standby server`

## What it means

Slot synchronization was invoked with a source that is itself a standby. Slots are synchronized from a primary to its standbys, so a standby cannot act as the source of the synchronization.

## When it happens

It occurs when `pg_sync_replication_slots()` runs while `primary_slot_name` or the configured source points at another standby rather than the primary.

## How to fix

Point slot synchronization at the primary server. Set the standby's `primary_conninfo` and related settings so it synchronizes from the primary, not from a cascaded standby.

## Example

*Illustrative* — sync sourced from a standby.

```text
ERROR:  cannot synchronize replication slots from a standby server
```

## Related

- [cannot synchronize replication slots concurrently](./cannot-synchronize-replication-slots-concurrently.md)
- [cannot synchronize local slot](./cannot-synchronize-local-slot.md)
