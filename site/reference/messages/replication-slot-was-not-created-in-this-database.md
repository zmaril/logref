---
message: "replication slot \"%s\" was not created in this database"
slug: replication-slot-was-not-created-in-this-database
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:361"
  - "postgres/src/backend/replication/logical/logical.c:522"
reproduced: false
---

# `replication slot "%s" was not created in this database`

## What it means

A database-specific (logical) replication slot was accessed from a different database than the one it was created in. The placeholder is the slot name. Logical slots are bound to the database that created them.

## When it happens

It arises when a `pg_logical_slot_get_changes` or a subscription/consumer tries to use a logical slot while connected to the wrong database.

## How to fix

Connect to the database in which the slot was created and use it there, or create a new logical slot in the database you actually need. Physical slots are not database-bound, but logical ones are.

## Example

*Illustrative* — reading a logical slot from the wrong database.

```text
ERROR:  replication slot "cdc_slot" was not created in this database
```

## Related

- [replication slot "%s" is active for PID %d](./replication-slot-is-active-for-pid.md)
- [scan started during logical decoding](./scan-started-during-logical-decoding.md)
