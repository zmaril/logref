---
message: "cannot attach foreign table \"%s\" as partition of partitioned table \"%s\""
slug: cannot-attach-foreign-table-as-partition-of-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21403"
reproduced: false
---

# `cannot attach foreign table "%s" as partition of partitioned table "%s"`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` named a foreign table as the partition, but the parent's configuration does not allow it. A foreign table can only be a partition of a plain partitioned table, not of one that requires local storage guarantees the foreign table cannot provide.

## When it happens

It occurs when attaching a foreign table under a partitioned table whose constraints — such as a primary key or certain index requirements — a foreign table cannot satisfy.

## How to fix

Attach the foreign table to a partitioned table that does not impose the unsupported guarantee, or use a local table for that partition. Review the parent's indexes and constraints, which foreign-table partitions cannot enforce.

## Example

*Illustrative* — a foreign table as partition.

```text
ERROR:  cannot attach foreign table "f" as partition of partitioned table "p"
```

## Related

- [cannot attach inheritance child as partition](./cannot-attach-inheritance-child-as-partition.md)
- [cannot attach a typed table as partition](./cannot-attach-a-typed-table-as-partition.md)
