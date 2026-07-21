---
message: "cannot restore from compressed archive (%s)"
slug: cannot-restore-from-compressed-archive
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:388"
reproduced: false
---

# `cannot restore from compressed archive (%s)`

## What it means

`pg_restore` could not read a compressed archive because the build lacks support for that compression method. The archive was written with a compression library this `pg_restore` was not compiled against. The placeholder names the compression method.

## When it happens

It occurs when restoring a custom-format dump compressed with a method (such as `lz4` or `zstd`) that the running `pg_restore` binary does not support.

## How to fix

Use a `pg_restore` built with support for the archive's compression method, or recreate the dump with a compression method your tools support. Match the client build's capabilities to the archive.

## Example

*Illustrative* — restoring an unsupported compressed archive.

```text
pg_restore: error: cannot restore from compressed archive (not built with zstd support)
```

## Related

- [cannot parse archive](./cannot-parse-archive.md)
- [cannot inject manifest into a compressed tar file](./cannot-inject-manifest-into-a-compressed-tar-file.md)
