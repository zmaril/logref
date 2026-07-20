---
message: "could not close archive status file \"%s\": %s"
slug: could-not-close-archive-status-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:73"
reproduced: false
---

# `could not close archive status file "%s": %s`

## What it means

`pg_basebackup` (receivelog) could not close an archive-status file it wrote while streaming WAL. The `%s` reason gives the error. The file was not cleanly closed.

## When it happens

It happens during WAL streaming when closing a `.done`/status file in the archive-status area fails, usually due to a filesystem or disk problem.

## How to fix

Check the destination filesystem's space, permissions, and health. Ensure the target directory is writable and not full or failing; resolve the underlying storage issue and rerun the backup/stream.

## Example

*Illustrative* — a failed archive-status file close.

```text
pg_basebackup: error: could not close archive status file "...": ...
```

## Related

- [could not close archive location](./could-not-close-archive-location.md)
- [could not close file](./could-not-close-file-677026.md)
