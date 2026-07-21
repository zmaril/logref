---
message: "could not generate temporary file name: %m"
slug: could-not-generate-temporary-file-name
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:378"
reproduced: false
---

# `could not generate temporary file name: %m`

## What it means

`pg_dump` tried to create a unique name for a scratch file while building a tar-format archive and the operating system call failed. The `%m` reason gives the cause. It needs the temporary file to stage archive members.

## When it happens

It happens during a tar-format dump when the temporary-file name cannot be produced — usually a missing or unwritable temporary directory, or a full temporary filesystem.

## How to fix

Make sure the temporary directory (`TMPDIR`, or the system default) exists, is writable, and has free space, then rerun the dump. Pointing `TMPDIR` at a roomier location helps when the default temp filesystem is small.

## Example

*Illustrative* — a temporary file name could not be created.

```text
pg_dump: fatal: could not generate temporary file name: No such file or directory
```

## Related

- [could not generate temporary file name for archiving](./could-not-generate-temporary-file-name-for-archiving.md)
- [could not initialize LZ4 compression](./could-not-initialize-lz4-compression.md)
