---
message: "cannot cluster on index \"%s\" because access method does not support clustering"
slug: cannot-cluster-on-index-because-access-method-does-not-support-clustering
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/repack.c:791"
reproduced: false
---

# `cannot cluster on index "%s" because access method does not support clustering`

## What it means

A `CLUSTER` command named an index whose access method cannot define a physical ordering for the table. Clustering reorders the table by an index, which requires an ordered access method such as B-tree. The placeholder is the index name.

## When it happens

It occurs when clustering on a non-ordered index type — for example a hash, GIN, or BRIN index.

## How to fix

Cluster on a B-tree index instead, since it provides the ordering `CLUSTER` needs. Create a suitable B-tree index on the columns you want the table ordered by.

## Example

*Illustrative* — clustering on a hash index.

```text
ERROR:  cannot cluster on index "t_hash" because access method does not support clustering
```

## Related

- [cannot cluster on partial index](./cannot-cluster-on-partial-index.md)
- [cannot cluster on invalid index](./cannot-cluster-on-invalid-index-3b22e6.md)
