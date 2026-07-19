---
message: "cannot create foreign partition of partitioned table \"%s\""
slug: cannot-create-foreign-partition-of-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:1338"
reproduced: false
---

# `cannot create foreign partition of partitioned table "%s"`

## What it means

A `CREATE FOREIGN TABLE ... PARTITION OF` tried to add a foreign table as a partition of a partitioned table whose configuration does not allow it. The parent imposes guarantees — such as an index or constraint — that a foreign partition cannot enforce. The placeholder is the parent name.

## When it happens

It occurs when creating a foreign partition under a partitioned table that requires local storage behavior the foreign table cannot provide.

## How to fix

Use a local table for that partition, or attach the foreign table under a partitioned parent without the unsupported requirement. Review the parent's indexes and constraints that a foreign partition cannot satisfy.

## Example

*Illustrative* — a foreign partition under a strict parent.

```text
ERROR:  cannot create foreign partition of partitioned table "p"
```

## Related

- [cannot attach foreign table as partition of partitioned table](./cannot-attach-foreign-table-as-partition-of-partitioned-table.md)
- [cannot create partitioned table as inheritance child](./cannot-create-partitioned-table-as-inheritance-child.md)
