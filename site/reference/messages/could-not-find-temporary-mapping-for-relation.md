---
message: "could not find temporary mapping for relation %u"
slug: could-not-find-temporary-mapping-for-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relmapper.c:454"
reproduced: false
---

# `could not find temporary mapping for relation %u`

## What it means

The relation mapper could not find the local, session-private mapping for a mapped relation. The mapper translates a few pinned catalogs from a relation number to a physical file, and temporary overrides live in a per-session table that came up empty for this relation.

## When it happens

It fires while resolving the storage of a mapped catalog after an operation that rewrites it, when the expected temporary mapping entry is absent. This is an internal invariant, not something a normal query reaches.

## How to fix

This is an internal guard. It can surface after an interrupted `VACUUM FULL` or `CLUSTER` on a system catalog, or with a corrupted relation map file. If it persists, the cluster likely needs to be restored from a backup; capture the relation number and the surrounding log and report it.

## Example

*Illustrative* — a missing temporary map entry for a mapped catalog.

```text
ERROR:  could not find temporary mapping for relation 1259
```

## Related

- [could not find tuple for parent of relation](./could-not-find-tuple-for-parent-of-relation.md)
- [could not identify relation associated with constraint](./could-not-identify-relation-associated-with-constraint.md)
