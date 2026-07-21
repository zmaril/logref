---
message: "could not finalize checksum of file \"%s\""
slug: could-not-finalize-checksum-of-file
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/backup_manifest.c:186"
reproduced: false
---

# `could not finalize checksum of file "%s"`

## What it means

The backup-manifest builder could not finalize the running checksum of a file it was recording. The `%s` names the file. This is an internal step of building the backup manifest.

## When it happens

It fires during a base backup while computing a file's manifest checksum, when the cryptographic finalization step fails — an internal or platform-level problem, not a data error.

## How to fix

This is an internal error. Check the server host for memory pressure or an unhealthy cryptographic library. If it recurs, note the backup settings (`manifest_checksums`) and report a reproducible case.

## Example

*Illustrative* — checksum finalization failing during backup.

```text
ERROR:  could not finalize checksum of file "base/1/1259"
```

## Related

- [could not extend file with FileFallocate()](./could-not-extend-file-with-filefallocate.md)
- [could not find any WAL files](./could-not-find-any-wal-files.md)
