---
message: "cannot create as partition of temporary relation of another session"
slug: cannot-create-as-partition-of-temporary-relation-of-another-session
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:23227"
reproduced: false
---

# `cannot create as partition of temporary relation of another session`

## What it means

A `CREATE TABLE ... PARTITION OF` targeted a temporary partitioned table that belongs to a different session. Temporary relations are private to their creating session, so another session cannot create partitions under them.

## When it happens

It occurs when the partitioned parent is a temporary table owned by a different backend than the one running the command.

## How to fix

Create partitions of a temporary table from the session that owns it, or use a permanent partitioned table when multiple sessions must cooperate. Temporary objects are never shared across sessions.

## Example

*Illustrative* — a foreign session's temporary parent.

```text
ERROR:  cannot create as partition of temporary relation of another session
```

## Related

- [cannot create a permanent relation as partition of temporary relation](./cannot-create-a-permanent-relation-as-partition-of-temporary-relation.md)
- [cannot attach as partition of temporary relation of another session](./cannot-attach-as-partition-of-temporary-relation-of-another-session.md)
