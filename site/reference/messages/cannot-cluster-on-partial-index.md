---
message: "cannot cluster on partial index \"%s\""
slug: cannot-cluster-on-partial-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/repack.c:803"
reproduced: false
---

# `cannot cluster on partial index "%s"`

## What it means

A `CLUSTER` command named a partial index — one defined with a `WHERE` clause. A partial index covers only some rows, so it cannot define an ordering for the entire table. The placeholder is the index name.

## When it happens

It occurs when clustering on an index built with a predicate that excludes part of the table.

## How to fix

Cluster on a full (non-partial) B-tree index over the desired columns. Create such an index if only partial ones exist on the table.

## Example

*Illustrative* — clustering on a partial index.

```text
ERROR:  cannot cluster on partial index "t_partial"
```

## Related

- [cannot cluster on index because access method does not support clustering](./cannot-cluster-on-index-because-access-method-does-not-support-clustering.md)
- [cannot cluster on invalid index](./cannot-cluster-on-invalid-index-3b22e6.md)
