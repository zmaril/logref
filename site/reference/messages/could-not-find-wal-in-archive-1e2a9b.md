---
message: "could not find WAL \"%s\" in archive \"%s\""
slug: could-not-find-wal-in-archive-1e2a9b
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/archive_waldump.c:516"
reproduced: false
---

# `could not find WAL "%s" in archive "%s"`

## What it means

`pg_waldump` was told to read a WAL segment from an archive and could not find the named file there. The `%s` values give the segment it wanted and the archive directory it searched.

## When it happens

It happens when running `pg_waldump` against an archive (rather than a live `pg_wal` directory) and the requested segment is absent — because it was never archived, was pruned, or the archive path is wrong.

## How to fix

Confirm the archive path and that the segment you asked for is present in it. If the segment was expired by your retention policy, choose a range that still exists; if the path is wrong, point `pg_waldump` at the directory that actually holds the archived segments.

## Example

*Illustrative* — a segment missing from the archive.

```text
pg_waldump: fatal: could not find WAL "000000010000000000000009" in archive "/var/lib/pg/archive"
```

## Related

- [could not find WAL in archive](./could-not-find-wal-in-archive-1ea321.md)
- [could not locate required checkpoint record at](./could-not-locate-required-checkpoint-record-at.md)
