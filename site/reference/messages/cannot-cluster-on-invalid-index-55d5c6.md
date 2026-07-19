---
message: "cannot cluster on invalid index %u"
slug: cannot-cluster-on-invalid-index-55d5c6
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:878"
reproduced: false
---

# `cannot cluster on invalid index %u`

## What it means

An internal path in clustering reported that the index it was told to cluster on is invalid, identifying it by its object identifier (OID). As with the by-name form, an invalid index cannot be used to physically reorder the table. The placeholder is the index OID.

## When it happens

It occurs when a cluster operation resolves to an index whose valid flag is false, reached through code that references the index by OID — for example automatic re-clustering of a previously clustered table.

## How to fix

Rebuild or drop the invalid index, then retry. Ensure the table's clustered index is valid before relying on `CLUSTER` without an explicit index name.

## Example

*Illustrative* — an invalid index by OID.

```text
ERROR:  cannot cluster on invalid index 16789
```

## Related

- [cannot cluster on invalid index (by name)](./cannot-cluster-on-invalid-index-3b22e6.md)
- [cannot cluster on index because access method does not support clustering](./cannot-cluster-on-index-because-access-method-does-not-support-clustering.md)
