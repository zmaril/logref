---
message: "pmchild freelist for backend type %d is corrupt"
slug: pmchild-freelist-for-backend-type-is-corrupt
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/postmaster/pmchild.c:203"
  - "postgres/src/backend/postmaster/pmchild.c:277"
reproduced: false
---

# `pmchild freelist for backend type %d is corrupt`

## What it means

Internal error in the postmaster. The free list that tracks available child-process slots for a given backend type was found in an inconsistent state. The placeholder is the backend-type code.

## When it happens

It fires from postmaster process-management code when the per-backend-type slot freelist fails its consistency check — a sign of memory corruption in the postmaster's own structures.

## How to fix

This is an internal guard indicating serious process-management corruption. Capture the log around it (and any preceding crash) and report it; a restart of the server clears the transient state, but a recurring occurrence warrants a bug report.

## Example

*Illustrative* — a corrupt postmaster child freelist.

```text
ERROR:  pmchild freelist for backend type 3 is corrupt
```

## Related

- [proclock table corrupted](./proclock-table-corrupted.md)
- [proc header uninitialized](./proc-header-uninitialized.md)
