---
message: "cannot create partitioned table as inheritance child"
slug: cannot-create-partitioned-table-as-inheritance-child
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:261"
reproduced: false
---

# `cannot create partitioned table as inheritance child`

## What it means

A `CREATE TABLE ... PARTITION BY ... INHERITS (...)` tried to make a partitioned table that is also a classic inheritance child. A partitioned table cannot inherit from another table, because partitioning and inheritance cannot be combined on the same relation.

## When it happens

It occurs when a `CREATE TABLE` specifies both `PARTITION BY` and `INHERITS`.

## How to fix

Choose one model: create the table either as partitioned or as an inheritance child, not both. Restructure the schema so a relation participates in a single hierarchy.

## Example

*Illustrative* — a partitioned inheritance child.

```sql
CREATE TABLE c () INHERITS (parent) PARTITION BY RANGE (a);
```

## Related

- [cannot create foreign partition of partitioned table](./cannot-create-foreign-partition-of-partitioned-table.md)
- [cannot attach inheritance parent as partition](./cannot-attach-inheritance-parent-as-partition.md)
