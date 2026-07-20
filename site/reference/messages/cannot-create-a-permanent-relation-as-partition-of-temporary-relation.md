---
message: "cannot create a permanent relation as partition of temporary relation \"%s\""
slug: cannot-create-a-permanent-relation-as-partition-of-temporary-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:23264"
reproduced: false
---

# `cannot create a permanent relation as partition of temporary relation "%s"`

## What it means

A `CREATE TABLE ... PARTITION OF` tried to create a permanent partition under a temporary partitioned table. A partition must match its parent's persistence, and a temporary parent can hold only temporary partitions. The placeholder is the parent name.

## When it happens

It occurs when creating a partition of a temporary partitioned table without marking the new partition `TEMPORARY`.

## How to fix

Create the partition as `TEMPORARY` to match the parent, or make the parent permanent if the data should persist. Persistence cannot differ between a partition and its parent.

## Example

*Illustrative* — a permanent partition under a temp parent.

```text
ERROR:  cannot create a permanent relation as partition of temporary relation "p"
```

## Related

- [cannot create as partition of temporary relation of another session](./cannot-create-as-partition-of-temporary-relation-of-another-session.md)
- [cannot attach a permanent relation as partition of temporary relation](./cannot-attach-a-permanent-relation-as-partition-of-temporary-relation.md)
