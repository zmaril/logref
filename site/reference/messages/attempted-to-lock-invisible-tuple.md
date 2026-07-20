---
message: "attempted to lock invisible tuple"
slug: attempted-to-lock-invisible-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/trigger.c:3483"
  - "postgres/src/backend/executor/execReplication.c:165"
  - "postgres/src/backend/executor/nodeLockRows.c:242"
  - "postgres/src/backend/executor/nodeModifyTable.c:3081"
  - "postgres/src/backend/utils/adt/ri_triggers.c:3335"
reproduced: false
---

# `attempted to lock invisible tuple`

## What it means

Internal error. Row-locking code (used by triggers and `SELECT ... FOR UPDATE`-style paths) tried to lock a tuple version that is not visible to the current snapshot. It is a consistency check: a lock should only ever be taken on a row the transaction can see.

## When it happens

It should not occur through normal SQL. Reaching it points to a bug in trigger or locking code, or to heap corruption, rather than to anything in your data.

## How to fix

Treat it as an internal bug. If it recurs on a specific table, check that table for corruption with `amcheck`/`pg_amcheck`. If it correlates with a custom trigger or extension, suspect that. Capture the operation and report it.

## Example

*Illustrative* — emitted internally during row locking.

```text
ERROR:  attempted to lock invisible tuple
```

## Related

- [could not obtain lock on row in relation](./could-not-obtain-lock-on-row-in-relation.md)
- [you don't own a lock of type](./you-don-t-own-a-lock-of-type.md)
