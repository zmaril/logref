---
message: "partition with name \"%s\" is already used"
slug: partition-with-name-is-already-used
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_TABLE
    code: "42P07"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:3687"
  - "postgres/src/backend/parser/parse_utilcmd.c:3695"
  - "postgres/src/backend/parser/parse_utilcmd.c:3748"
  - "postgres/src/backend/parser/parse_utilcmd.c:3777"
reproduced: false
---

# `partition with name "%s" is already used`

## What it means

A `CREATE TABLE ... PARTITION OF` (or a partition list in `CREATE TABLE ... PARTITION BY`) named the same partition twice, or reused a name already taken by an existing partition. The placeholder is the duplicate name. Partition names within a partitioned table must be distinct.

## When it happens

Defining partitions where two of them share a name — often a copy-paste in a multi-partition statement, or attaching a partition whose name collides with an existing child.

## How to fix

Give each partition a unique name. Rename the duplicate, or if the partition already exists, drop/rename the old one before reusing the name. Check the full partition list in the statement for repeats.

## Example

*Illustrative* — the same partition name twice.

```sql
CREATE TABLE t (a int) PARTITION BY LIST (a);
CREATE TABLE p1 PARTITION OF t FOR VALUES IN (1);
CREATE TABLE p1 PARTITION OF t FOR VALUES IN (2);  -- name already used
```

## Related

- [relation already exists, skipping](./relation-already-exists-skipping.md)
- [every hash partition modulus must be a factor of the next larger modulus](./every-hash-partition-modulus-must-be-a-factor-of-the-next-larger-modulus.md)
