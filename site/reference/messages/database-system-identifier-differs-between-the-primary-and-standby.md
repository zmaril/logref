---
message: "database system identifier differs between the primary and standby"
slug: database-system-identifier-differs-between-the-primary-and-standby
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/walreceiver.c:333"
reproduced: false
---

# `database system identifier differs between the primary and standby`

## What it means

A standby's WAL receiver found that the primary's database system identifier does not match its own. The system identifier is a unique value stamped into a cluster at `initdb` time; two servers in one replication pair must share it. The server reports it as the object not being in the required state.

## When it happens

It fires when a standby connects to a primary that is not actually its origin — for example the standby was pointed at a different cluster, or was rebuilt from a different base than the primary.

## How to fix

Make sure the standby was created from a base backup of this exact primary. A standby can only stream from the cluster it was cloned from. If the identifiers differ, rebuild the standby with `pg_basebackup` (or equivalent) from the intended primary.

## Example

*Illustrative* — mismatched system identifiers.

```text
ERROR:  database system identifier differs between the primary and standby
DETAIL:  The primary's identifier is 7180000000000000000, the standby's identifier is 7180000000000000001.
```

## Related

- [could not receive database system identifier and timeline ID from the primary server](./could-not-receive-database-system-identifier-and-timeline-id-from-the-primary.md)
- [database cluster is not compatible](./database-cluster-is-not-compatible.md)
