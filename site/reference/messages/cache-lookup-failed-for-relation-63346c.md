---
message: "cache lookup failed for relation \"%s\""
slug: cache-lookup-failed-for-relation-63346c
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19123"
reproduced: false
---

# `cache lookup failed for relation "%s"`

## What it means

An internal lookup for a relation found no catalog row for it. The placeholder is the relation name. The table, index, or other relation referenced by an operation is missing or the catalog is inconsistent.

## When it happens

It usually reflects a race with a concurrent `DROP` of the relation, or, less often, catalog corruption in `pg_class`.

## How to fix

Retry the operation if concurrent DDL dropped the relation. If it persists with nothing dropping it, investigate `pg_class` consistency, run `amcheck` on suspect indexes, and consider a restore from backup.

## Example

*Illustrative* — a missing relation.

```text
ERROR:  cache lookup failed for relation "orders"
```

## Related

- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
- [cache lookup failed for partition key of](./cache-lookup-failed-for-partition-key-of.md)
