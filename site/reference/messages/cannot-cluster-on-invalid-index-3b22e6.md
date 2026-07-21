---
message: "cannot cluster on invalid index \"%s\""
slug: cannot-cluster-on-invalid-index-3b22e6
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/repack.c:817"
reproduced: false
---

# `cannot cluster on invalid index "%s"`

## What it means

A `CLUSTER` command named an index that is marked invalid — for example one left behind by a failed concurrent build. An invalid index does not fully cover the table, so it cannot be used to reorder it. The placeholder is the index name.

## When it happens

It occurs when clustering on an index whose `indisvalid` flag is false, typically after an interrupted `CREATE INDEX CONCURRENTLY`.

## How to fix

Drop the invalid index and rebuild it, or cluster on a different valid index. Once a valid index exists on the desired columns, `CLUSTER` can use it.

## Example

*Illustrative* — clustering on an invalid index.

```text
ERROR:  cannot cluster on invalid index "t_idx"
```

## Related

- [cannot cluster on invalid index (by oid)](./cannot-cluster-on-invalid-index-55d5c6.md)
- [cannot cluster on index because access method does not support clustering](./cannot-cluster-on-index-because-access-method-does-not-support-clustering.md)
