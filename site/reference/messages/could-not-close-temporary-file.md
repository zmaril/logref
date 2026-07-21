---
message: "could not close temporary file: %m"
slug: could-not-close-temporary-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:1023"
reproduced: false
---

# `could not close temporary file: %m`

## What it means

`pg_dump` could not close a temporary file it used while building a tar-format archive. The `%m` reason gives the OS error. The close failure means the temporary data may be incomplete.

## When it happens

It happens during a tar-format dump when closing a scratch file fails, typically from a full temporary filesystem or an I/O error.

## How to fix

Check free space and health of the filesystem holding the temporary directory, then rerun the dump. Setting `TMPDIR` to a location with more room can help when the default temp filesystem is small.

## Example

*Illustrative* — a failed temporary-file close during a tar dump.

```text
pg_dump: fatal: could not close temporary file: No space left on device
```

## Related

- [could not create compressed file](./could-not-create-compressed-file.md)
- [could not create communication channels](./could-not-create-communication-channels.md)
