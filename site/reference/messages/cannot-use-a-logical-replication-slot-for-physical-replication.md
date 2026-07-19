---
message: "cannot use a logical replication slot for physical replication"
slug: cannot-use-a-logical-replication-slot-for-physical-replication
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/walsender.c:882"
reproduced: false
---

# `cannot use a logical replication slot for physical replication`

## What it means

A physical replication client asked to use a slot that was created as a logical replication slot. The two slot kinds track different things, so a logical slot cannot be consumed by a physical walsender.

## When it happens

It occurs when a standby or `pg_receivewal` connects with `primary_slot_name` or `--slot` set to a logical slot instead of a physical one.

## How to fix

Create and use a physical slot for physical replication with `pg_create_physical_replication_slot()` or `pg_receivewal --create-slot`, and reserve logical slots for logical decoding clients.

## Example

*Illustrative* — a logical slot used physically.

```text
ERROR:  cannot use a logical replication slot for physical replication
```

## Related

- [cannot use replication slot for logical decoding](./cannot-use-replication-slot-for-logical-decoding.md)
- [cannot synchronize local slot](./cannot-synchronize-local-slot.md)
