---
message: "cannot attach as partition of temporary relation of another session"
slug: cannot-attach-as-partition-of-temporary-relation-of-another-session
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21184"
reproduced: false
---

# `cannot attach as partition of temporary relation of another session`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` targeted a temporary partitioned table that belongs to a different session. Temporary relations are private to the session that created them, so another session cannot attach partitions under them.

## When it happens

It occurs when the partitioned parent is a temporary table owned by a different backend than the one running the command.

## How to fix

Run partition operations on temporary tables from the session that owns them. Temporary objects are not shared across sessions; use a permanent partitioned table if multiple sessions must cooperate.

## Example

*Illustrative* — a foreign session's temporary parent.

```text
ERROR:  cannot attach as partition of temporary relation of another session
```

## Related

- [cannot attach temporary relation of another session as partition](./cannot-attach-temporary-relation-of-another-session-as-partition.md)
- [cannot attach a temporary relation as partition of permanent relation](./cannot-attach-a-temporary-relation-as-partition-of-permanent-relation.md)
