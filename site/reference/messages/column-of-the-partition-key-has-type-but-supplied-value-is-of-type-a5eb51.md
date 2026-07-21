---
message: "column %d of the partition key has type \"%s\", but supplied value is of type \"%s\""
slug: column-of-the-partition-key-has-type-but-supplied-value-is-of-type-a5eb51
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:4892"
reproduced: false
---

# `column %d of the partition key has type "%s", but supplied value is of type "%s"`

## What it means

A partition bound value's type did not match the partition-key column's type. This variant quotes the type names; the meaning is the same as the unquoted form — bound and key types must agree.

## When it happens

It happens on `CREATE TABLE ... PARTITION OF ... FOR VALUES ...` when a bound value cannot be coerced to the key column's type.

## How to fix

Cast the bound values to the key column's type or supply values that already match. Verify the parent's partition-key column types before writing the bounds.

## Example

*Illustrative* — a partition bound whose type does not match the key.

```text
ERROR:  column 1 of the partition key has type "integer", but supplied value is of type "text"
```

## Related

- [column of the partition key has type but supplied value is of type](./column-of-the-partition-key-has-type-but-supplied-value-is-of-type-2f9098.md)
- [column named in partition key does not exist](./column-named-in-partition-key-does-not-exist.md)
