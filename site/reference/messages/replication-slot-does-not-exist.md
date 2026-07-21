---
message: "replication slot \"%s\" does not exist"
slug: replication-slot-does-not-exist
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/replication/slot.c:648"
  - "postgres/src/backend/replication/slotfuncs.c:687"
  - "postgres/src/backend/utils/activity/pgstat_replslot.c:53"
  - "postgres/src/backend/utils/adt/genfile.c:738"
  - "postgres/src/bin/pg_basebackup/streamutil.c:532"
reproduced: true
---

# `replication slot "%s" does not exist`

## What it means

A command referenced a replication slot by name that is not present on the server. The placeholder is the slot name. Replication slots (physical or logical) are named cluster objects; referring to one that was never created or has been dropped produces this.

## When it happens

Advancing, reading, or dropping a slot (`pg_drop_replication_slot`, `pg_replication_slot_advance`, `START_REPLICATION SLOT`) or a subscriber/standby referencing a slot name that does not exist on the upstream.

## How to fix

List slots with `SELECT slot_name FROM pg_replication_slots` and correct the name, or create the slot with `pg_create_physical_replication_slot`/`pg_create_logical_replication_slot`. For subscriptions, ensure the slot on the publisher matches the subscription's `slot_name`.

## Example

*Reproduced* — captured from `reproducers/scenarios/22_system_admin_funcs.sql`.

```sql
SELECT pg_drop_replication_slot('nonexistent_slot_xyz');
```

Produces:

```text
ERROR:  replication slot "nonexistent_slot_xyz" does not exist
```

## Related

- [subscription does not exist](./subscription-does-not-exist.md)
- [could not receive data from WAL stream](./could-not-receive-data-from-wal-stream.md)
