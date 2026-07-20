---
message: "cannot specify storage parameters for a partitioned table"
slug: cannot-specify-storage-parameters-for-a-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/access/common/reloptions.c:2132"
reproduced: false
---

# `cannot specify storage parameters for a partitioned table`

## What it means

A partitioned table was given storage parameters in a `WITH (...)` clause. A partitioned table holds no data itself, so table-level storage parameters have nothing to apply to and are rejected.

## When it happens

It occurs on `CREATE TABLE ... PARTITION BY ... WITH (...)` or `ALTER TABLE ... SET (...)` against the partitioned parent with storage options such as `fillfactor`.

## How to fix

Set storage parameters on the individual partitions, which hold the rows, rather than on the partitioned parent. Remove the `WITH` clause from the parent definition.

## Example

*Illustrative* — storage parameters on a partitioned parent.

```sql
CREATE TABLE t (a int) PARTITION BY RANGE (a) WITH (fillfactor = 70);
-- ERROR:  cannot specify storage parameters for a partitioned table
```

## Related

- [cannot use constant expression as partition key](./cannot-use-constant-expression-as-partition-key.md)
- [cannot truncate only a partitioned table](./cannot-truncate-only-a-partitioned-table.md)
