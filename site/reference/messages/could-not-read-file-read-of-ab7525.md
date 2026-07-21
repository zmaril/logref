---
message: "could not read file \"%s\": read %zd of %zu"
slug: could-not-read-file-read-of-ab7525
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:2147"
reproduced: false
---

# `could not read file "%s": read %zd of %zu`

## What it means

The server's base-backup code read a file to stream it to a backup client but received fewer bytes than expected. The values give the bytes read against the amount requested. A short read means the file changed size or is damaged mid-backup.

## When it happens

It fires during a server-side base backup when a read of a data file returns too few bytes — usually a file truncated concurrently, or an I/O error on the data directory.

## How to fix

Check the data directory's storage health, since a short read here points at an I/O problem or concurrent truncation. Retry the backup; if it recurs, investigate the underlying storage for faults.

## Example

*Illustrative* — a short read while streaming a backup.

```text
ERROR:  could not read file "base/16384/16400": read 4096 of 8192
```

## Related

- [could not read file: read of](./could-not-read-file-read-of-4dc01a.md)
- [could not read from file at offset](./could-not-read-from-file-at-offset.md)
