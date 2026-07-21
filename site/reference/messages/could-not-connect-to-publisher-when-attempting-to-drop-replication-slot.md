---
message: "could not connect to publisher when attempting to drop replication slot \"%s\": %s"
slug: could-not-connect-to-publisher-when-attempting-to-drop-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:3573"
reproduced: false
---

# `could not connect to publisher when attempting to drop replication slot "%s": %s`

## What it means

While dropping a subscription, the subscriber tried to connect to the publisher to remove the associated replication slot and could not reach it. The `%s` reason gives the connection error.

## When it happens

It happens during `DROP SUBSCRIPTION` (or when disabling slot management) when the publisher is down, unreachable, or the stored connection info is no longer valid.

## How to fix

Restore connectivity to the publisher and retry, or drop the subscription without slot removal using `ALTER SUBSCRIPTION ... SET (slot_name = NONE)` first and then drop the leftover slot on the publisher manually with `pg_drop_replication_slot`.

## Example

*Illustrative* — the publisher unreachable during subscription drop.

```text
ERROR:  could not connect to publisher when attempting to drop replication slot "sub_slot": connection refused
```

## Related

- [could not copy replication slot](./could-not-copy-replication-slot.md)
- [could not create replication slot](./could-not-create-replication-slot.md)
