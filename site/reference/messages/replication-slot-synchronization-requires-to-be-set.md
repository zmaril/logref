---
message: "replication slot synchronization requires \"%s\" to be set"
slug: replication-slot-synchronization-requires-to-be-set
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:1220"
  - "postgres/src/backend/replication/logical/slotsync.c:1248"
reproduced: false
---

# `replication slot synchronization requires "%s" to be set`

## What it means

Synchronizing replication slots from a primary to a standby needs a particular configuration parameter set, and it was not, so the slot-sync feature cannot operate.

## When it happens

It is reported when standby slot synchronization is requested but a prerequisite such as `hot_standby_feedback`, a configured `primary_conninfo`/`primary_slot_name`, or `sync_replication_slots` is missing.

## Is this a problem?

The severity depends on the caller — treat it as a configuration prerequisite. Set the named parameter on the standby (typically `hot_standby_feedback = on` plus a valid `primary_conninfo` and slot name), reload, and confirm slot sync can proceed. Failed sync means the standby cannot maintain copies of the primary's logical slots.

## Example

*Illustrative* — slot sync missing a required setting.

```text
LOG:  replication slot synchronization requires "hot_standby_feedback" to be set
```

## Related

- [all replication slots are in use](./all-replication-slots-are-in-use.md)
- [apply worker for subscription could not connect to the publisher](./apply-worker-for-subscription-could-not-connect-to-the-publisher.md)
