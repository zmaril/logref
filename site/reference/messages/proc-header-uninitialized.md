---
message: "proc header uninitialized"
slug: proc-header-uninitialized
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/storage/lmgr/proc.c:402"
  - "postgres/src/backend/storage/lmgr/proc.c:633"
reproduced: false
---

# `proc header uninitialized`

## What it means

Internal error (PANIC). A process tried to use its PGPROC entry — the shared-memory structure describing a backend to the rest of the server — before it had been initialized. Continuing would corrupt shared state, so the server aborts.

## When it happens

It fires from process-startup or lock/wait code that dereferences the current process's PGPROC before setup completed. It indicates an ordering or memory-corruption fault in the server, not a user action.

## How to fix

This is an internal invariant. The PANIC forces a restart and recovery. Capture the log around it and report a reproducible case; recurring occurrences point to a build or memory-corruption problem.

## Example

*Illustrative* — a backend using its PGPROC before initialization.

```text
PANIC:  proc header uninitialized
```

## Related

- [proclock table corrupted](./proclock-table-corrupted.md)
- [pmchild freelist for backend type %d is corrupt](./pmchild-freelist-for-backend-type-is-corrupt.md)
