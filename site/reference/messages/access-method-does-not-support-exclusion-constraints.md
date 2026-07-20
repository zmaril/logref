---
message: "access method \"%s\" does not support exclusion constraints"
slug: access-method-does-not-support-exclusion-constraints
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:899"
reproduced: false
---

# `access method "%s" does not support exclusion constraints`

## What it means

An exclusion constraint was requested on an index access method that cannot enforce one, because it lacks the capabilities exclusion constraints rely on.

## When it happens

It occurs with `ALTER TABLE ... ADD CONSTRAINT EXCLUDE USING method (...)` (or the equivalent in `CREATE TABLE`) when `method` is not one that supports exclusion, such as hash.

## How to fix

Use an access method that supports exclusion constraints — typically GiST (common for range and geometric overlap constraints) or B-tree for equality-based exclusions. Change the `USING` clause to a supported method.

## Example

*Illustrative* — an exclusion constraint on an unsupported method.

```sql
ALTER TABLE t ADD EXCLUDE USING hash (c WITH =);  -- hash cannot back an exclusion constraint
```

## Related

- [access method does not support WITHOUT OVERLAPS constraints](./access-method-does-not-support-without-overlaps-constraints.md)
- [access method does not support unique indexes](./access-method-does-not-support-unique-indexes.md)
