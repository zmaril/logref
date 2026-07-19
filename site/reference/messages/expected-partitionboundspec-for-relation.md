---
message: "expected PartitionBoundSpec for relation %u"
slug: expected-partitionboundspec-for-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:5091"
reproduced: false
---

# `expected PartitionBoundSpec for relation %u`

## What it means

An internal guard in partition handling. Loading the bound for a specific partition, the code expected a `PartitionBoundSpec` and found a different node type. The placeholder is the relation OID.

## When it happens

It fires while the server reads a partition's bound from the catalog if the stored value is not the expected node shape. In a healthy catalog this does not happen.

## How to fix

This is an internal invariant pointing at catalog inconsistency rather than a user error. Investigate the partition's `pg_class`/`pg_partitioned_table` entries if it followed a crash or interrupted DDL. Capture the details and report it if the table was built normally.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected PartitionBoundSpec for relation 16491
```

## Related

- [expected PartitionBoundSpec](./expected-partitionboundspec.md)
- [expected partdefid but got](./expected-partdefid-but-got.md)
