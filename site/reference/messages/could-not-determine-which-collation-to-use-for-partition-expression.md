---
message: "could not determine which collation to use for partition expression"
slug: could-not-determine-which-collation-to-use-for-partition-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20726"
reproduced: false
---

# `could not determine which collation to use for partition expression`

## What it means

A partitioned table's partition key involves a collatable type, but PostgreSQL could not decide which collation to use for it. The choice was left ambiguous.

## When it happens

It happens during `CREATE TABLE ... PARTITION BY` when the partition key expression mixes collatable inputs of different collations, or uses one with no determinable collation.

## How to fix

Add an explicit `COLLATE` clause to the partition key expression so the collation is fixed, for example `PARTITION BY RANGE (name COLLATE "C")`.

## Example

*Illustrative* — a partition key with an ambiguous collation.

```sql
CREATE TABLE t (a text, b text) PARTITION BY RANGE (a || b);
-- ERROR:  could not determine which collation to use for partition expression
```

## Related

- [could not determine which collation to use for index expression](./could-not-determine-which-collation-to-use-for-index-expression.md)
- [could not determine which collation to use for view column](./could-not-determine-which-collation-to-use-for-view-column.md)
