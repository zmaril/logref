---
message: "cannot enable failover for a replication slot on the standby"
slug: cannot-enable-failover-for-a-replication-slot-on-the-standby
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/slot.c:979"
reproduced: false
---

# `cannot enable failover for a replication slot on the standby`

## What it means

An operation tried to enable failover on a replication slot while connected to a standby. The failover property is managed on the primary and synchronized outward, so it cannot be turned on from the standby side.

## When it happens

It occurs when altering a slot's failover setting on a standby server.

## How to fix

Enable failover on the primary; standbys receive the synchronized slots. Do not set the failover property on a slot from a standby.

## Example

*Illustrative* — enabling failover on the standby.

```text
ERROR:  cannot enable failover for a replication slot on the standby
```

## Related

- [cannot enable failover for a replication slot created on the standby](./cannot-enable-failover-for-a-replication-slot-created-on-the-standby.md)
- [cannot enable retain_dead_tuples if the publisher is in recovery](./cannot-enable-retain-dead-tuples-if-the-publisher-is-in-recovery.md)
