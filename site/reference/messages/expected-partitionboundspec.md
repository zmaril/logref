---
message: "expected PartitionBoundSpec"
slug: expected-partitionboundspec
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:4317"
reproduced: false
---

# `expected PartitionBoundSpec`

## What it means

An internal guard in partition-bound handling. Code expected a `PartitionBoundSpec` node (the parsed representation of a partition's `FOR VALUES` bound) and received a different node type. It is a node-shape check.

## When it happens

It fires while processing partition bounds if the internal node tree does not have the expected structure. The parser normally produces the right node, so reaching this is unexpected.

## How to fix

This is an internal "can't happen" invariant, not something a user configures. If a routine `CREATE TABLE ... PARTITION OF` or `ATTACH PARTITION` triggers it, capture the exact DDL and report it as a bug. There is no configuration workaround.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected PartitionBoundSpec
```

## Related

- [expected PartitionBoundSpec for relation](./expected-partitionboundspec-for-relation.md)
- [expected partdefid but got](./expected-partdefid-but-got.md)
