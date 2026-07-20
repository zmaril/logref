---
message: "subscription with OID %u does not exist"
slug: subscription-with-oid-does-not-exist
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:2996"
  - "postgres/src/bin/pg_dump/pg_dump.c:5409"
reproduced: false
---

# `subscription with OID %u does not exist`

## What it means

A lookup for a subscription by its OID found no such subscription. The placeholder is the OID. The subscription was dropped, or an internal reference points to one that no longer exists. It can be reported as an error or, in some paths, as a fatal apply-worker condition.

## When it happens

It arises when apply-worker or catalog code resolves a subscription by OID that has since been removed — for example a `DROP SUBSCRIPTION` racing with an apply worker, or a stale reference.

## How to fix

Usually transient: if the subscription was intentionally dropped, the message reflects that and the worker will exit. If unexpected, verify the subscription in `pg_subscription` and recreate it if it should exist. Persistent internal references to a missing OID warrant a bug report.

## Example

*Illustrative* — resolving a dropped subscription by OID.

```text
ERROR:  subscription with OID 16510 does not exist
```

## Related

- [subscription owner "%s" does not have permission on foreign server "%s"](./subscription-owner-does-not-have-permission-on-foreign-server.md)
- [synchronization worker "%s" could not connect to the primary server: %s](./synchronization-worker-could-not-connect-to-the-primary-server.md)
