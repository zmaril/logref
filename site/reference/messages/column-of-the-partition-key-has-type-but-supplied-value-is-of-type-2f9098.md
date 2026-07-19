---
message: "column %d of the partition key has type %s, but supplied value is of type %s"
slug: column-of-the-partition-key-has-type-but-supplied-value-is-of-type-2f9098
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:4854"
reproduced: false
---

# `column %d of the partition key has type %s, but supplied value is of type %s`

## What it means

A partition bound value did not match the type of the corresponding partition-key column, and no cast applied. Bound values must be the same type as the key columns they constrain.

## When it happens

It happens on `CREATE TABLE ... PARTITION OF ... FOR VALUES ...` when a bound literal's type differs from the partition key column's type.

## How to fix

Supply bound values of the correct type, or cast them explicitly to the key column's type. Check the partition-key column types on the parent table.

## Example

*Illustrative* — a partition bound of the wrong type.

```text
ERROR:  column 1 of the partition key has type integer, but supplied value is of type text
```

## Related

- [column of the partition key has type but supplied value is of type](./column-of-the-partition-key-has-type-but-supplied-value-is-of-type-a5eb51.md)
- [column named in partition key does not exist](./column-named-in-partition-key-does-not-exist.md)
