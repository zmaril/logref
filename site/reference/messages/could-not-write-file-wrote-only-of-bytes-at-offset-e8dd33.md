---
message: "could not write file \"%s\": wrote only %d of %zu bytes at offset %lld"
slug: could-not-write-file-wrote-only-of-bytes-at-offset-e8dd33
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DISK_FULL
    code: "53100"
call_sites:
  - "postgres/src/backend/backup/basebackup_server.c:177"
  - "postgres/src/backend/backup/basebackup_server.c:270"
reproduced: false
---

# `could not write file "%s": wrote only %d of %zu bytes at offset %lld`

## What it means

A server-side base backup to a file target wrote fewer bytes than requested at an offset. The `%s` is the path, the counts are written versus wanted, and the offset is where it stopped. Classified as a disk-full condition.

## When it happens

The backup target ran out of space (or hit a quota or an I/O error) while the server streamed a file into a server-side base backup.

## How to fix

Free space on the backup target or point it at a larger location, then rerun the backup. The partial output is unusable — remove it before retrying.

## Example

*Illustrative* — the server-side backup target filled up.

```text
ERROR:  could not write file "/backups/base.tar": wrote only 4096 of 8192 bytes at offset 1048576
```

## Related

- [could not write file: wrote of](./could-not-write-file-wrote-of-c8a991.md)
- [could not write to file](./could-not-write-to-file-ecc639.md)
