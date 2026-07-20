---
message: "cache lookup failed for attribute %s of relation %u"
slug: cache-lookup-failed-for-attribute-of-relation-3023f5
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/sepgsql/dml.c:123"
  - "postgres/src/backend/catalog/heap.c:2132"
reproduced: false
---

# `cache lookup failed for attribute %s of relation %u`

## What it means

Internal error. Code looked up a column of a relation in the system caches by name and got no result. The message reports the attribute and the relation's identifier. It is a consistency check: the column should exist at that point.

## When it happens

It should not occur in normal operation. Reaching it usually means the column was dropped concurrently, or points to a catalog inconsistency, rather than to your query.

## How to fix

If a concurrent schema change dropped the column, retry the operation after the change settles. If it recurs for a stable column, it may indicate catalog inconsistency worth investigating; capture the operation and the identifiers and report it.

## Example

*Illustrative* — a failed attribute cache lookup.

```text
ERROR:  cache lookup failed for attribute a of relation 16472
```

## Related

- [cache lookup failed for attribute of relation](./cache-lookup-failed-for-attribute-of-relation-8cf7a7.md)
- [attribute of relation with oid does not exist](./attribute-of-relation-with-oid-does-not-exist.md)
