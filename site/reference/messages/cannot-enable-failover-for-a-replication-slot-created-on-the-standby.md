---
message: "cannot enable failover for a replication slot created on the standby"
slug: cannot-enable-failover-for-a-replication-slot-created-on-the-standby
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/slot.c:406"
reproduced: false
---

# `cannot enable failover for a replication slot created on the standby`

## What it means

An operation tried to enable failover on a logical replication slot that was created on a standby server. Failover slots are synchronized from a primary to standbys, so a slot that originated on the standby cannot itself be a failover slot.

## When it happens

It occurs when setting the failover property on a slot whose origin is a standby rather than the primary.

## How to fix

Create failover-enabled logical slots on the primary, where they can be synchronized to standbys. A slot made on the standby cannot take on the failover role.

## Example

*Illustrative* — failover on a standby-created slot.

```text
ERROR:  cannot enable failover for a replication slot created on the standby
```

## Related

- [cannot enable failover for a replication slot on the standby](./cannot-enable-failover-for-a-replication-slot-on-the-standby.md)
- [cannot enable subscription that does not have a slot name](./cannot-enable-subscription-that-does-not-have-a-slot-name.md)
