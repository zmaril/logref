---
message: "could not create background thread: %m"
slug: could-not-create-background-thread
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:739"
reproduced: false
---

# `could not create background thread: %m`

## What it means

`pg_basebackup` could not create the background thread it uses to stream WAL alongside the base backup. The `%m` reason gives the OS error. This is the Windows counterpart of the background-process path.

## When it happens

It happens on Windows when `pg_basebackup` starts background WAL streaming and the thread creation fails, usually from resource limits on the host.

## How to fix

Check the host for resource exhaustion and reduce concurrent load, then rerun the backup.

## Example

*Illustrative* — the background thread failing to start.

```text
pg_basebackup: fatal: could not create background thread: ...reason...
```

## Related

- [could not create background process](./could-not-create-background-process.md)
- [could not create pipe for background process](./could-not-create-pipe-for-background-process.md)
