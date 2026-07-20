---
message: "cannot swap mapped relation \"%s\" with non-mapped relation"
slug: cannot-swap-mapped-relation-with-non-mapped-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1617"
reproduced: false
---

# `cannot swap mapped relation "%s" with non-mapped relation`

## What it means

An internal guard fired during a relation swap, such as the rebuild step of `CLUSTER` or `VACUUM FULL`. One relation is a mapped catalog (tracked in the relation map) and the other is not, and the swap code cannot exchange a mapped relation with an ordinary one.

## When it happens

It is reached from the storage-swap path when rebuilding a table. It reflects an internal inconsistency, not a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, the relation names, and the server log, then report it. It points to catalog corruption or a bug in the swap code.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot swap mapped relation "pg_class" with non-mapped relation
```

## Related

- [cannot swap toast by links for mapped relation](./cannot-swap-toast-by-links-for-mapped-relation.md)
- [cannot swap toast files by links for system catalogs](./cannot-swap-toast-files-by-links-for-system-catalogs.md)
