---
message: "could not locate WAL file \"%s\""
slug: could-not-locate-wal-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:324"
reproduced: false
---

# `could not locate WAL file "%s"`

## What it means

`pg_waldump` was asked to read a specific WAL segment and could not find the file. The `%s` value names the segment. It reads WAL from a directory or the running server's `pg_wal`, and the named file was not there.

## When it happens

It happens when the segment you named does not exist in the directory `pg_waldump` is reading — a wrong path, a segment that was already recycled, or a typo in the file name.

## How to fix

Confirm the WAL directory and the segment name, and pick a segment that still exists there. If the segment was recycled or archived away, read it from the archive instead, or choose a WAL range that is still present.

## Example

*Illustrative* — the named WAL segment was not found.

```text
pg_waldump: fatal: could not locate WAL file "000000010000000000000009"
```

## Related

- [could not open write-ahead log file](./could-not-open-write-ahead-log-file.md)
- [could not read from file, offset](./could-not-read-from-file-offset.md)
