---
message: "could not unmap shared memory segment \"%s\": %m"
slug: could-not-unmap-shared-memory-segment
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_impl.c:230"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:536"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:640"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:811"
reproduced: false
---

# `could not unmap shared memory segment "%s": %m`

## What it means

The server could not unmap a dynamic shared memory segment from a process's address space. The placeholders are the segment name and the OS error. Unmapping releases a segment a backend had attached; a failure is unusual because the address was mapped successfully earlier.

## When it happens

It is rare and generally reflects an OS-level inconsistency — an already-unmapped region, or memory-management state disturbed by something outside normal operation.

## Is this a problem?

Read the appended OS error. In isolation it is usually not actionable and does not corrupt data, but repeated occurrences suggest an OS memory-management problem worth investigating (kernel logs, memory pressure). Report reproducible cases with the OS error and platform details.

## Example

*Illustrative* — a DSM segment that could not be unmapped.

```text
LOG:  could not unmap shared memory segment "/PostgreSQL.123": Invalid argument
```

## Related

- [could not map shared memory segment](./could-not-map-shared-memory-segment.md)
- [could not stat shared memory segment](./could-not-stat-shared-memory-segment.md)
