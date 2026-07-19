---
message: "could not close file \"%s/%s\": %m"
slug: could-not-close-file-677026
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/archive_waldump.c:503"
reproduced: false
---

# `could not close file "%s/%s": %m`

## What it means

`pg_waldump` (archive path) could not close a WAL file it opened. The `%m` reason gives the OS error. The close failed.

## When it happens

It happens in `pg_waldump` when closing a WAL segment file from an archive directory fails, typically due to a filesystem problem.

## How to fix

Read the OS reason and check the filesystem holding the WAL files for health and permissions. Resolve the storage issue and rerun; a close failure usually points at an underlying disk or mount problem.

## Example

*Illustrative* — a failed WAL-file close in pg_waldump.

```text
pg_waldump: fatal: could not close file "arch/000000010000000000000001": ...
```

## Related

- [could not close archive status file](./could-not-close-archive-status-file.md)
- [could not close input file](./could-not-close-input-file.md)
