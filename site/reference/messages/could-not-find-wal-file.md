---
message: "could not find WAL file \"%s\""
slug: could-not-find-wal-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:499"
  - "postgres/src/backend/backup/basebackup.c:514"
  - "postgres/src/backend/backup/basebackup.c:523"
reproduced: false
---

# `could not find WAL file "%s"`

## What it means

The server or a tool needed a specific WAL segment file and could not locate it. The placeholder is the file name. Base backup, replication, and recovery all read WAL segments by name; a missing one means the required log is not present where it was expected.

## When it happens

WAL was recycled or removed before it could be read, a slot did not retain it, an archive is missing the segment, or a base backup requested a segment no longer on disk.

## How to fix

Ensure the needed WAL is retained: use a replication slot or an adequate `wal_keep_size`/archive so segments are not recycled prematurely, and verify the archive actually contains the named file. For recovery, restore the segment from the archive. If it was legitimately recycled, the operation must start from a point whose WAL still exists.

## Example

*Illustrative* — a required WAL segment missing.

```text
ERROR:  could not find WAL file "000000010000000000000005"
```

## Related

- [could not find a valid record after](./could-not-find-a-valid-record-after-dd2f88.md)
- [could not read file read of](./could-not-read-file-read-of-2ed767.md)
