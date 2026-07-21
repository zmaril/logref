---
message: "foreign key constraint \"%s\" cannot be implemented"
slug: foreign-key-constraint-cannot-be-implemented
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_COLLATION_MISMATCH
    code: "42P21"
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10578"
  - "postgres/src/backend/commands/tablecmds.c:10612"
reproduced: true
---

# `foreign key constraint "%s" cannot be implemented`

## What it means

A foreign key could not be created because the referencing and referenced columns are not comparable. The `%s` is the constraint name. The detail explains a type or collation mismatch between the key columns.

## When it happens

Defining a foreign key whose columns have types with no usable equality operator between them, or incompatible collations, so the reference cannot be enforced.

## How to fix

Make the referencing and referenced columns type-compatible (matching or implicitly comparable types) and collation-compatible. Adjust the column types or collations, then add the foreign key.

## Example

*Reproduced* — captured from `reproducers/scenarios/36_constraints_partitioning.sql`.

```sql
ALTER TABLE s36.fkt ADD FOREIGN KEY (r) REFERENCES s36.pkt (id);
```

Produces:

```text
ERROR:  foreign key constraint "fkt_r_fkey" cannot be implemented
```

## Related

- [foreign key uses PERIOD on the referenced table but not the referencing table](./foreign-key-uses-period-on-the-referenced-table-but-not-the-referencing-table.md)
- [empty range bound specified for partition](./empty-range-bound-specified-for-partition.md)
