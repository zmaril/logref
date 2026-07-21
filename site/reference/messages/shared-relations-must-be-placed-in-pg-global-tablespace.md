---
message: "shared relations must be placed in pg_global tablespace"
slug: shared-relations-must-be-placed-in-pg-global-tablespace
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/heap.c:1223"
  - "postgres/src/backend/catalog/index.c:884"
reproduced: false
---

# `shared relations must be placed in pg_global tablespace`

## What it means

Internal/administrative error. A shared (cluster-wide) system catalog was directed to a tablespace other than `pg_global`. Shared relations, which are visible to every database, are required to live in the `pg_global` tablespace.

## When it happens

It fires from low-level catalog/storage code if a shared relation's tablespace assignment is anything but `pg_global`. Ordinary user tables never trigger it; it concerns shared system catalogs.

## How to fix

This is an internal invariant. It should not arise from normal DDL; if it does, it indicates an unexpected attempt to relocate a shared catalog. Capture the operation and report it, and do not attempt to move shared catalogs out of `pg_global`.

## Example

*Illustrative* — a shared catalog assigned a non-global tablespace.

```text
ERROR:  shared relations must be placed in pg_global tablespace
```

## Related

- [tablespace "%s" already exists](./tablespace-already-exists.md)
- [unacceptable tablespace name "%s"](./unacceptable-tablespace-name.md)
