---
message: "could not start background worker for enabling data checksums in database \"%s\""
slug: could-not-start-background-worker-for-enabling-data-checksums-in-database
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/src/backend/postmaster/datachecksum_state.c:870"
  - "postgres/src/backend/postmaster/datachecksum_state.c:894"
reproduced: false
---

# `could not start background worker for enabling data checksums in database "%s"`

## What it means

A warning that the server could not launch the background worker that enables data checksums in a database, so checksum-enabling did not proceed for it.

## When it happens

It arises during online data-checksum enabling when a worker slot is unavailable or the worker fails to start — often because `max_worker_processes` is exhausted.

## Is this a problem?

Ensure free background-worker slots (`max_worker_processes`) and retry the checksum-enabling operation. Check for other errors around the failed launch; the process resumes once a worker can start.

## Example

*Illustrative* — a checksum worker that would not start.

```text
WARNING:  could not start background worker for enabling data checksums in database "app"
```

## Related

- [data checksum processing aborted in database OID %u](./data-checksum-processing-aborted-in-database-oid.md)
- [worker process failed: exit code %d](./worker-process-failed-exit-code.md)
