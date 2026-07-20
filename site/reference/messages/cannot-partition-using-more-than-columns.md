---
message: "cannot partition using more than %d columns"
slug: cannot-partition-using-more-than-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_COLUMNS
    code: "54011"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:1282"
reproduced: false
---

# `cannot partition using more than %d columns`

## What it means

A `CREATE TABLE ... PARTITION BY` listed more partition-key columns than allowed. Postgres caps the number of columns in a partition key, and the definition exceeded it. The placeholder is the maximum column count.

## When it happens

It occurs when the partition-key expression names more columns than the limit.

## How to fix

Reduce the partition key to the allowed number of columns. Combine columns into a single expression where feasible, or reconsider the partitioning scheme so it needs fewer key columns.

## Example

*Illustrative* — too many partition-key columns.

```text
ERROR:  cannot partition using more than 32 columns
```

## Related

- [cannot have more than keys in a foreign key](./cannot-have-more-than-keys-in-a-foreign-key.md)
- [cannot pass more than argument to a procedure](./cannot-pass-more-than-argument-to-a-procedure.md)
