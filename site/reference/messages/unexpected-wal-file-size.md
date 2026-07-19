---
message: "unexpected WAL file size \"%s\""
slug: unexpected-wal-file-size
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:564"
  - "postgres/src/backend/backup/basebackup.c:589"
reproduced: false
---

# `unexpected WAL file size "%s"`

## What it means

A tool or the server opened a WAL segment file whose size does not match the configured segment size, so it refused to treat the file as a valid segment.

## When it happens

It arises in WAL-handling paths and tools (`pg_receivewal`, recovery, archiving) when a segment file is truncated, still being written, or came from a cluster initialized with a different WAL segment size.

## How to fix

Ensure WAL segments are complete and match this cluster's segment size (`pg_controldata` reports it). Remove or re-fetch a partial file, and never mix segments from clusters initialized with different `--wal-segsize` values.

## Example

*Illustrative* — a WAL segment of the wrong size.

```text
ERROR:  unexpected WAL file size "000000010000000000000004"
```

## Related

- [unexpected WAL source %d](./unexpected-wal-source.md)
- [unrecognized "wal_sync_method": %d](./unrecognized-wal-sync-method.md)
