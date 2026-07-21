---
message: "could not find WAL in archive \"%s\""
slug: could-not-find-wal-in-archive-1ea321
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/archive_waldump.c:188"
reproduced: false
---

# `could not find WAL in archive "%s"`

## What it means

`pg_waldump` searched an archive for the WAL segment it needed and found nothing to read. The `%s` value names the archive directory it looked in.

## When it happens

It happens when `pg_waldump` reads from an archive and cannot locate any matching segment — an empty or wrong archive directory, or a starting position with no archived WAL behind it.

## How to fix

Point `pg_waldump` at the directory that holds your archived WAL, and pick a start position covered by segments that are still retained. If the archive is genuinely empty for that range, the WAL you want is no longer available.

## Example

*Illustrative* — no matching segment in the archive.

```text
pg_waldump: fatal: could not find WAL in archive "/var/lib/pg/archive"
```

## Related

- [could not find WAL in archive](./could-not-find-wal-in-archive-1e2a9b.md)
- [could not get size of write-ahead log file](./could-not-get-size-of-write-ahead-log-file.md)
