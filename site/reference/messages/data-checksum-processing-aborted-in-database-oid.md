---
message: "data checksum processing aborted in database OID %u"
slug: data-checksum-processing-aborted-in-database-oid
passthrough: false
api: [ereport]
level: [DEBUG1, LOG]
call_sites:
  - "postgres/src/backend/postmaster/datachecksum_state.c:1700"
  - "postgres/src/backend/postmaster/datachecksum_state.c:1773"
reproduced: false
---

# `data checksum processing aborted in database OID %u`

## What it means

A message that online data-checksum processing was aborted for a database, identified by OID, before it finished.

## When it happens

It arises when enabling or disabling data checksums online is interrupted — a cancel, a shutdown, or a worker failure stops the per-database processing.

## Is this a problem?

Re-run the checksum operation so it can complete for the affected database. Check for a preceding error or cancellation that stopped it, and ensure worker slots and resources are available for the retry.

## Example

*Illustrative* — checksum processing aborted for a database.

```text
LOG:  data checksum processing aborted in database OID 16401
```

## Related

- [could not start background worker for enabling data checksums in database "%s"](./could-not-start-background-worker-for-enabling-data-checksums-in-database.md)
- [worker process failed: exit code %d](./worker-process-failed-exit-code.md)
