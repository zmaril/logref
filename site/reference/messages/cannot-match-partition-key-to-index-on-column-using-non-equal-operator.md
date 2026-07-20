---
message: "cannot match partition key to index on column \"%s\" using non-equal operator \"%s\""
slug: cannot-match-partition-key-to-index-on-column-using-non-equal-operator
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:1089"
reproduced: false
---

# `cannot match partition key to index on column "%s" using non-equal operator "%s"`

## What it means

A unique or primary-key index on a partitioned table could not be matched to the partition key because a column comparison uses a non-equality operator. A unique constraint on a partitioned table must include the partition-key columns compared by equality, and this index did not. The placeholders are the column name and the operator.

## When it happens

It occurs when you create a unique index or constraint on a partitioned table whose partitioning uses an operator class that compares the key column with something other than plain equality (for example a hash or range operator that does not provide equality matching for the constraint).

## How to fix

Include the partition-key columns in the unique constraint using an equality-based operator class, or change the partitioning or index so the key columns match by equality. A unique constraint on a partitioned table must cover the partition key.

## Example

*Illustrative* — a unique index that misses the partition key.

```text
ERROR:  cannot match partition key to index on column "id" using non-equal operator "&&"
```

## Related

- [cannot have more than keys in a foreign key](./cannot-have-more-than-keys-in-a-foreign-key.md)
- [cannot mark inherited constraint as](./cannot-mark-inherited-constraint-as.md)
