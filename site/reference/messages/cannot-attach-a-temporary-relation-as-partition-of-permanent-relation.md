---
message: "cannot attach a temporary relation as partition of permanent relation \"%s\""
slug: cannot-attach-a-temporary-relation-as-partition-of-permanent-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21169"
reproduced: false
---

# `cannot attach a temporary relation as partition of permanent relation "%s"`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` tried to attach a temporary table to a permanent partitioned table. A partition must match its parent's persistence, and a permanent parent cannot hold a temporary partition.

## When it happens

It occurs when the partitioned parent is permanent but the table being attached is `TEMPORARY`.

## How to fix

Match persistence: attach a permanent table to a permanent parent. If the data is genuinely temporary, keep it in a separate temporary table rather than as a partition of a permanent one.

## Example

*Illustrative* — temporary partition, permanent parent.

```text
ERROR:  cannot attach a temporary relation as partition of permanent relation "p"
```

## Related

- [cannot attach a permanent relation as partition of temporary relation](./cannot-attach-a-permanent-relation-as-partition-of-temporary-relation.md)
- [cannot attach as partition of temporary relation of another session](./cannot-attach-as-partition-of-temporary-relation-of-another-session.md)
