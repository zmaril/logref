---
message: "could not close archive location \"%s\": %m"
slug: could-not-close-archive-location
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:173"
reproduced: false
---

# `could not close archive location "%s": %m`

## What it means

`pg_archivecleanup` could not close the archive directory it opened. The `%m` reason gives the OS error. The tool fails because it could not cleanly release the location.

## When it happens

It happens at the end of a `pg_archivecleanup` run when closing the archive directory handle fails, typically due to an underlying filesystem problem.

## How to fix

Read the OS reason and check the archive filesystem's health and permissions. A close failure often signals storage trouble (a disconnected mount, I/O error); resolve the filesystem issue and rerun.

## Example

*Illustrative* — a failed archive-directory close.

```text
pg_archivecleanup: fatal: could not close archive location "/arch": ...
```

## Related

- [could not close archive status file](./could-not-close-archive-status-file.md)
- [could not close filter file](./could-not-close-filter-file.md)
