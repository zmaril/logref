---
message: "cannot attach a permanent relation as partition of temporary relation \"%s\""
slug: cannot-attach-a-permanent-relation-as-partition-of-temporary-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21177"
reproduced: false
---

# `cannot attach a permanent relation as partition of temporary relation "%s"`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` tried to attach a permanent table to a temporary partitioned table. A partition must match its parent's persistence, and a temporary parent can only hold temporary partitions.

## When it happens

It occurs when the partitioned parent is `TEMPORARY` but the table being attached is an ordinary permanent table.

## How to fix

Match persistence: attach a temporary table to a temporary parent, or make the parent permanent if you intend to store permanent partitions. Persistence cannot differ between a partition and its parent.

## Example

*Illustrative* — permanent partition, temporary parent.

```text
ERROR:  cannot attach a permanent relation as partition of temporary relation "p"
```

## Related

- [cannot attach a temporary relation as partition of permanent relation](./cannot-attach-a-temporary-relation-as-partition-of-permanent-relation.md)
- [cannot attach temporary relation of another session as partition](./cannot-attach-temporary-relation-of-another-session-as-partition.md)
