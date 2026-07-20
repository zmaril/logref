---
message: "could not fetch failover logical slots info from the primary server: %s"
slug: could-not-fetch-failover-logical-slots-info-from-the-primary-server
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:957"
reproduced: false
---

# `could not fetch failover logical slots info from the primary server: %s`

## What it means

A standby running slot synchronization could not read the set of failover-enabled logical slots from the primary. The `%s` gives the reason. The slot-sync worker could not learn which slots to mirror.

## When it happens

It happens on a standby with `sync_replication_slots` enabled when the query to the primary for failover-slot information fails, usually from a lost or misconfigured primary connection.

## How to fix

Check the standby's connection to the primary (`primary_conninfo`) and the primary's availability. Confirm the connecting role has the rights to read replication-slot information, then let the slot-sync worker retry.

## Example

*Illustrative* — failover-slot info fetch failing on a standby.

```text
ERROR:  could not fetch failover logical slots info from the primary server: ...reason...
```

## Related

- [could not fetch primary slot name info from the primary server](./could-not-fetch-primary-slot-name-info-from-the-primary-server.md)
- [could not establish database-specific replication connection](./could-not-establish-database-specific-replication-connection.md)
