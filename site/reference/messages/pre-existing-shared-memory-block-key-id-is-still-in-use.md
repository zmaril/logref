---
message: "pre-existing shared memory block (key %lu, ID %lu) is still in use"
slug: pre-existing-shared-memory-block-key-id-is-still-in-use
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_LOCK_FILE_EXISTS
    code: "F0001"
call_sites:
  - "postgres/src/backend/port/sysv_shmem.c:798"
  - "postgres/src/backend/utils/init/miscinit.c:1355"
reproduced: false
---

# `pre-existing shared memory block (key %lu, ID %lu) is still in use`

## What it means

At startup the server found an existing System V shared-memory segment (identified by the reported key and ID) that is still attached to running processes, so it will not reuse or clobber it. It usually means another server instance is still alive, or orphaned backends remain.

## When it happens

It arises when starting a server whose data directory already has a live shared-memory segment — a second start attempt, a previous instance that did not shut down cleanly, or leftover backend processes holding the segment.

## How to fix

Confirm no other postmaster is running on that data directory (`pg_ctl status`, `ps`). Stop any lingering instance and terminate orphaned backends holding the segment before starting again. Do not force-remove the segment while processes are attached.

## Example

*Illustrative* — starting a server whose shared-memory segment is still live.

```text
FATAL:  pre-existing shared memory block (key 5432001, ID 98304) is still in use
```

## Related

- [reattaching to shared memory returned unexpected address (got %p, expected %p)](./reattaching-to-shared-memory-returned-unexpected-address-got-expected.md)
- [the database system is not yet accepting connections](./the-database-system-is-not-yet-accepting-connections.md)
