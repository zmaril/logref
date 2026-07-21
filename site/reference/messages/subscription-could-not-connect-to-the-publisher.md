---
message: "subscription \"%s\" could not connect to the publisher: %s"
slug: subscription-could-not-connect-to-the-publisher
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:958"
  - "postgres/src/backend/commands/subscriptioncmds.c:1122"
  - "postgres/src/backend/commands/subscriptioncmds.c:1374"
  - "postgres/src/backend/commands/subscriptioncmds.c:2380"
reproduced: true
---

# `subscription "%s" could not connect to the publisher: %s`

## What it means

A logical replication subscription failed to open a connection to its publisher. The placeholders are the subscription name and the underlying connection error. The subscriber connects to the publisher using the subscription's `CONNECTION` string; if that connection cannot be made, replication cannot start or continue.

## When it happens

The publisher is down or unreachable, the connection string is wrong (host, port, database, credentials), `pg_hba.conf` on the publisher rejects the subscriber's login or does not allow replication, or the network path is blocked.

## How to fix

Read the appended connection error — it names the real cause. Verify the publisher is running and reachable, and that the subscription's connection string is correct (`SELECT subconninfo FROM pg_subscription` for superusers). On the publisher, confirm `pg_hba.conf` permits the role from the subscriber's address and that the role has `REPLICATION` privilege and `max_wal_senders`/slot capacity is available. Fix the connection, then the subscription's worker will retry automatically.

## Example

*Reproduced* — this site fired under `reproducers/scenarios/61_pub_sub.sh`; see the reproducer for the triggering workload. It emits:

```text
ERROR:  subscription "%s" could not connect to the publisher: %s
```

## Related

- [publication does not exist](./publication-does-not-exist.md)
- [could not send query](./could-not-send-query.md)
