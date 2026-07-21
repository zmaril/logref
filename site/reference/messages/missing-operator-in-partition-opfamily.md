---
message: "missing operator %d(%u,%u) in partition opfamily %u"
slug: missing-operator-in-partition-opfamily
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:1022"
  - "postgres/src/backend/partitioning/partbounds.c:3839"
reproduced: false
---

# `missing operator %d(%u,%u) in partition opfamily %u`

## What it means

Internal error. Partitioning code looked for a comparison operator in a partition key's operator family and did not find it. The placeholders identify the strategy, operand types, and opfamily. It is a consistency guard over partition-key support.

## When it happens

It fires during partition bound computation or pruning when the operator family backing a partition key lacks an operator the code expects. Ordinary partitioned queries do not surface it; it points to an incomplete or damaged operator family, sometimes from a custom opclass.

## How to fix

This is a can't-happen guard for built-in opclasses. If a custom operator class backs the partition key, ensure it provides the full set of ordering operators. Capture the partitioned table's key definition and report a reproducible case.

## Example

*Illustrative* — a missing operator in a partition opfamily.

```text
ERROR:  missing operator 1(23,23) in partition opfamily 16600
```

## Related

- [missing oprcode for operator](./missing-oprcode-for-operator.md)
- [operator class does not accept data type](./operator-class-does-not-accept-data-type.md)
