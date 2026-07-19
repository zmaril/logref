---
message: "a hash-partitioned table may not have a default partition"
slug: a-hash-partitioned-table-may-not-have-a-default-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:4860"
reproduced: false
---

# `a hash-partitioned table may not have a default partition`

## What it means

A command tried to attach or create a default partition on a hash-partitioned table, which is not allowed because hash partitioning already assigns every possible key to some partition.

## When it happens

It occurs when you run `CREATE TABLE ... PARTITION OF hash_table DEFAULT` or attach a default partition to a table partitioned `BY HASH`.

## How to fix

Do not define a default partition under hash partitioning — there is nothing for it to catch, since hash partitions cover the whole key space by modulus/remainder. Create the regular hash partitions with explicit modulus and remainder values instead. Default partitions apply only to list and range partitioning.

## Example

*Illustrative* — a default partition under hash partitioning.

```sql
CREATE TABLE p_default PARTITION OF h DEFAULT;  -- h is PARTITION BY HASH
```

## Related

- [ALTER TABLE / ADD CONSTRAINT USING INDEX is not supported on partitioned tables](./alter-table-add-constraint-using-index-is-not-supported-on-partitioned-tables.md)
- [array of serial is not implemented](./array-of-serial-is-not-implemented.md)
