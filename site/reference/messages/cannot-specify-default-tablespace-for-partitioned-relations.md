---
message: "cannot specify default tablespace for partitioned relations"
slug: cannot-specify-default-tablespace-for-partitioned-relations
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:798"
  - "postgres/src/backend/commands/tablecmds.c:945"
  - "postgres/src/backend/commands/tablespace.c:1190"
reproduced: false
---

# `cannot specify default tablespace for partitioned relations`

## What it means

A `TABLESPACE` clause was placed on a partitioned table itself, which stores no data of its own. The placeholder-free message reflects that a partitioned table is only a routing parent; giving it a default tablespace is meaningless because it holds no heap, and Postgres rejects the clause to avoid confusion about where data lands.

## When it happens

Adding `TABLESPACE x` to `CREATE TABLE ... PARTITION BY ...` (the partitioned parent), rather than to the individual partitions.

## How to fix

Put the tablespace on the partitions, not the parent: specify `TABLESPACE` on each `CREATE TABLE ... PARTITION OF`, or set a `default_tablespace` before creating partitions. If you want new partitions to inherit a location, manage that per-partition or via `default_tablespace` at creation time.

## Example

*Illustrative* — a tablespace on the partitioned parent.

```sql
CREATE TABLE t (a int) PARTITION BY RANGE (a) TABLESPACE ts;  -- not allowed
```

## Related

- [only shared relations can be placed in pg_global tablespace](./only-shared-relations-can-be-placed-in-pg-global-tablespace.md)
- [every hash partition modulus must be a factor of the next larger modulus](./every-hash-partition-modulus-must-be-a-factor-of-the-next-larger-modulus.md)
