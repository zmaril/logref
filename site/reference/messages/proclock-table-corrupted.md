---
message: "proclock table corrupted"
slug: proclock-table-corrupted
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:1149"
  - "postgres/src/backend/storage/lmgr/lock.c:1767"
reproduced: false
---

# `proclock table corrupted`

## What it means

Internal error (PANIC). The shared PROCLOCK hash table — which records which processes hold which locks — failed a consistency check. The lock manager cannot proceed safely, so the server aborts.

## When it happens

It fires from lock-manager code when the PROCLOCK structure is found inconsistent, a sign of shared-memory corruption. It is not caused by ordinary SQL.

## How to fix

This is an internal invariant guard. The PANIC triggers a restart and recovery. Capture the surrounding log and report it; recurring occurrences indicate memory corruption, faulty hardware, or a server bug.

## Example

*Illustrative* — a corrupt lock-manager table.

```text
PANIC:  proclock table corrupted
```

## Related

- [proc header uninitialized](./proc-header-uninitialized.md)
- [pmchild freelist for backend type %d is corrupt](./pmchild-freelist-for-backend-type-is-corrupt.md)
