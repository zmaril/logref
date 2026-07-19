---
message: "cannot create unique index on partitioned table \"%s\""
slug: cannot-create-unique-index-on-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:1414"
  - "postgres/src/backend/tcop/utility.c:1519"
reproduced: false
---

# `cannot create unique index on partitioned table "%s"`

## What it means

A `CREATE UNIQUE INDEX` on a partitioned table did not include all the partition-key columns. The placeholder is the table name. A unique index on a partitioned table must cover every partition-key column so uniqueness can be enforced per partition.

## When it happens

Creating a unique index (or a `UNIQUE`/`PRIMARY KEY` constraint) on a partitioned table whose column list omits one or more of the partition-key columns.

## How to fix

Add every partition-key column to the unique index's column list. Postgres can only guarantee global uniqueness on a partitioned table when the key includes the partitioning columns; extend the index definition accordingly.

## Example

*Illustrative* — a unique index missing the partition key.

```sql
CREATE UNIQUE INDEX ON parted (id);  -- partitioned by created_at
-- ERROR:  cannot create unique index on partitioned table "parted"
```

## Related

- [cannot change owner of index](./cannot-change-owner-of-index.md)
- [concurrent index creation for exclusion constraints is not supported](./concurrent-index-creation-for-exclusion-constraints-is-not-supported.md)
