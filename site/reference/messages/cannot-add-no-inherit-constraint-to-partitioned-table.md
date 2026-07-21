---
message: "cannot add NO INHERIT constraint to partitioned table \"%s\""
slug: cannot-add-no-inherit-constraint-to-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/catalog/heap.c:2220"
reproduced: true
---

# `cannot add NO INHERIT constraint to partitioned table "%s"`

## What it means

A `NO INHERIT` constraint was defined on a partitioned table. A partitioned table's constraints must apply to its partitions, so a `NO INHERIT` constraint, which deliberately does not propagate, is not allowed. The placeholder is the table.

## When it happens

It occurs in `CREATE TABLE` or `ALTER TABLE ... ADD CONSTRAINT ... NO INHERIT` on a partitioned table.

## How to fix

Define the constraint without `NO INHERIT` so it applies across the partitions, or attach the constraint to individual partitions if it should be local to them. Partitioned tables require their constraints to be inheritable.

## Example

*Reproduced* — captured from `reproducers/scenarios/31_createtable_view_trigger.sql`.

```sql
CREATE TABLE repro.ct24 (a int, CONSTRAINT c CHECK (a > 0) NO INHERIT) PARTITION BY LIST (a);
```

Produces:

```text
ERROR:  cannot add NO INHERIT constraint to partitioned table "ct24"
```

## Related

- [cannot add identity to a column of only the partitioned table](./cannot-add-identity-to-a-column-of-only-the-partitioned-table.md)
- [cannot alter constraint on relation](./cannot-alter-constraint-on-relation.md)
