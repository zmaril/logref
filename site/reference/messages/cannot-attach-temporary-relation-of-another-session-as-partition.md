---
message: "cannot attach temporary relation of another session as partition"
slug: cannot-attach-temporary-relation-of-another-session-as-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21190"
reproduced: false
---

# `cannot attach temporary relation of another session as partition`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` named a temporary table that belongs to a different session as the partition. Temporary relations are private to their creating session and cannot be attached by another backend.

## When it happens

It occurs when the table being attached is a temporary table owned by a different session than the one running the command.

## How to fix

Attach temporary tables from the session that created them, or use permanent tables if partitions must be managed across sessions. Temporary objects are never shared between backends.

## Example

*Illustrative* — a foreign session's temporary table.

```text
ERROR:  cannot attach temporary relation of another session as partition
```

## Related

- [cannot attach as partition of temporary relation of another session](./cannot-attach-as-partition-of-temporary-relation-of-another-session.md)
- [cannot attach a permanent relation as partition of temporary relation](./cannot-attach-a-permanent-relation-as-partition-of-temporary-relation.md)
