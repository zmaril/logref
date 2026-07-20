---
message: "unexpected WAL source %d"
slug: unexpected-wal-source
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:3734"
  - "postgres/src/backend/access/transam/xlogrecovery.c:4002"
reproduced: false
---

# `unexpected WAL source %d`

## What it means

Internal error. The WAL-reading machinery was told to read from a source (stream, archive, or local pg_wal) that is not one of the defined sources.

## When it happens

It fires in recovery/replay code when the current WAL source value is outside the known set. Normal recovery does not produce it.

## How to fix

This is an internal consistency guard. Capture the recovery configuration and surrounding log and report it as a reproducible bug if a normal recovery reaches it.

## Example

*Illustrative* — an unknown WAL source.

```text
ERROR:  unexpected WAL source 4
```

## Related

- [unexpected WAL file size "%s"](./unexpected-wal-file-size.md)
- [unrecognized "wal_sync_method": %d](./unrecognized-wal-sync-method.md)
