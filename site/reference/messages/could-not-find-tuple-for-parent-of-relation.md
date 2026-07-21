---
message: "could not find tuple for parent of relation %u"
slug: could-not-find-tuple-for-parent-of-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/partition.c:65"
reproduced: false
---

# `could not find tuple for parent of relation %u`

## What it means

Partitioning code looked up the `pg_inherits` row that records a partition's parent and did not find it. Every partition or inheritance child has a row naming its parent, and this lookup returned nothing.

## When it happens

It fires while resolving a partition's parent, when the inheritance link is missing — typically because the parent or the attachment was changed concurrently, or the catalog is inconsistent.

## How to fix

This is an internal guard. Confirm the partition is still attached and its parent still exists, and avoid altering the partition hierarchy concurrently with the operation. On stable definitions, note the relation OID and report a reproducible case.

## Example

*Illustrative* — a partition with no recorded parent.

```text
ERROR:  could not find tuple for parent of relation 16620
```

## Related

- [could not find temporary mapping for relation](./could-not-find-temporary-mapping-for-relation.md)
- [could not identify relation associated with constraint](./could-not-identify-relation-associated-with-constraint.md)
