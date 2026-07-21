---
message: "synchronization worker \"%s\" could not connect to the primary server: %s"
slug: synchronization-worker-could-not-connect-to-the-primary-server
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/replication/logical/slotsync.c:1708"
  - "postgres/src/backend/replication/slotfuncs.c:951"
reproduced: false
---

# `synchronization worker "%s" could not connect to the primary server: %s`

## What it means

A logical replication table-synchronization worker failed to connect to the upstream (publisher) server. The placeholders are the worker/subscription name and the connection error. Initial table copy cannot proceed without the connection.

## When it happens

It arises during a subscription's initial sync when the sync worker cannot reach the publisher — wrong connection string, authentication failure, network problem, or the publisher being down or at its connection limit.

## How to fix

Read the connection error in the detail. Verify the subscription's `conninfo`, credentials, `pg_hba.conf` on the publisher, network reachability, and available connection slots. Once connectivity is restored the worker retries automatically.

## Example

*Illustrative* — a sync worker failing to reach the publisher.

```text
ERROR:  synchronization worker "sub_orders" could not connect to the primary server: connection refused
```

## Related

- [subscription with OID %u does not exist](./subscription-with-oid-does-not-exist.md)
- [terminating connection due to conflict with recovery](./terminating-connection-due-to-conflict-with-recovery.md)
