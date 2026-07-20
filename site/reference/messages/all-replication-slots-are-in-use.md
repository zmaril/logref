---
message: "all replication slots are in use"
slug: all-replication-slots-are-in-use
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIGURATION_LIMIT_EXCEEDED
    code: "53400"
call_sites:
  - "postgres/src/backend/replication/slot.c:459"
reproduced: false
---

# `all replication slots are in use`

## What it means

A new replication slot was requested, but the number of existing slots has reached `max_replication_slots`, so there is no free slot to allocate.

## When it happens

It occurs when creating a physical or logical replication slot (directly, or implicitly by a subscriber or standby) once all configured slots are taken.

## How to fix

Drop unused replication slots you no longer need (check `pg_replication_slots` for inactive ones), or raise `max_replication_slots` and restart. Leftover slots from removed standbys or subscriptions are a common cause, and inactive slots also pin WAL, so clean them up.

## Example

*Illustrative* — creating a slot with none free.

```sql
SELECT pg_create_physical_replication_slot('s');  -- ERROR:  all replication slots are in use
```

## Related

- [all AuxiliaryProcs are in use](./all-auxiliaryprocs-are-in-use.md)
- [replication slot synchronization requires to be set](./replication-slot-synchronization-requires-to-be-set.md)
