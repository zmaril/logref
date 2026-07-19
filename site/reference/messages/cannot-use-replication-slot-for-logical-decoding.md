---
message: "cannot use replication slot \"%s\" for logical decoding"
slug: cannot-use-replication-slot-for-logical-decoding
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:533"
reproduced: false
---

# `cannot use replication slot "%s" for logical decoding`

## What it means

A logical decoding client asked to use a slot that was created as a physical replication slot. Physical slots carry no logical-decoding state, so a logical decoding session cannot run on one.

## When it happens

It occurs when a logical decoding client, such as `pg_recvlogical` or a `START_REPLICATION ... LOGICAL` command, names a physical slot.

## How to fix

Create a logical slot with `pg_create_logical_replication_slot()` (or `pg_recvlogical --create-slot`) and use that for decoding. Reserve physical slots for physical replication.

## Example

*Illustrative* — a physical slot used for decoding.

```text
ERROR:  cannot use replication slot "phys_slot" for logical decoding
```

## Related

- [cannot use a logical replication slot for physical replication](./cannot-use-a-logical-replication-slot-for-physical-replication.md)
- [cannot synchronize local slot](./cannot-synchronize-local-slot.md)
