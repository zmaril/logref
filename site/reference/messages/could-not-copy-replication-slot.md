---
message: "could not copy replication slot \"%s\""
slug: could-not-copy-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/slotfuncs.c:807"
reproduced: false
---

# `could not copy replication slot "%s"`

## What it means

A `pg_copy_logical_replication_slot` or `pg_copy_physical_replication_slot` call could not duplicate the source slot. A follow-on detail usually explains why the copy was rejected.

## When it happens

It happens when copying a replication slot whose state does not permit duplication — for example a logical slot that has not yet reached a consistent point, or a source and target with incompatible properties.

## How to fix

Check the accompanying detail line for the specific reason. Make sure the source slot is a valid, active slot of the matching kind and that the target name is not already in use. Retry once the source slot is in a copyable state.

## Example

*Illustrative* — a slot that cannot be copied yet.

```sql
SELECT pg_copy_logical_replication_slot('src', 'dst');
-- ERROR:  could not copy replication slot "src"
```

## Related

- [could not create replication slot](./could-not-create-replication-slot.md)
- [could not connect to publisher when attempting to drop replication slot](./could-not-connect-to-publisher-when-attempting-to-drop-replication-slot.md)
