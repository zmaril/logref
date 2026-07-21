---
message: "could not fetch primary slot name \"%s\" info from the primary server: %s"
slug: could-not-fetch-primary-slot-name-info-from-the-primary-server
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:1122"
reproduced: false
---

# `could not fetch primary slot name "%s" info from the primary server: %s`

## What it means

A standby running slot synchronization could not read information about the primary's configured slot. The `%s` values name the slot and give the reason. The slot-sync worker could not verify the primary slot.

## When it happens

It happens on a standby with slot synchronization enabled when the query to the primary about its `primary_slot_name` slot fails, usually from a lost or misconfigured primary connection.

## How to fix

Check the standby's `primary_conninfo` and `primary_slot_name`, confirm the named slot exists on the primary, and verify the connecting role can read slot information. Let the slot-sync worker retry once the primary is reachable.

## Example

*Illustrative* — primary-slot info fetch failing on a standby.

```text
ERROR:  could not fetch primary slot name "standby_slot" info from the primary server: ...reason...
```

## Related

- [could not fetch failover logical slots info from the primary server](./could-not-fetch-failover-logical-slots-info-from-the-primary-server.md)
- [could not establish database-specific replication connection](./could-not-establish-database-specific-replication-connection.md)
