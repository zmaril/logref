---
message: "could not find any WAL file"
slug: could-not-find-any-wal-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:326"
reproduced: false
---

# `could not find any WAL file`

## What it means

`pg_waldump` could not find any WAL file to read in the location it was pointed at. Without a segment to open it has nothing to dump.

## When it happens

It happens at `pg_waldump` startup when the target directory holds no WAL segments, or the specified starting point falls outside the available files.

## How to fix

Point `pg_waldump` at a directory that contains WAL segments (a cluster's `pg_wal`, or an archive), or supply a start LSN that falls within the segments present. Check the path and any `--start`/`--end` bounds.

## Example

*Illustrative* — no WAL segments where pg_waldump looked.

```text
pg_waldump: fatal: could not find any WAL file
```

## Related

- [could not find any WAL files](./could-not-find-any-wal-files.md)
- [could not find file](./could-not-find-file.md)
