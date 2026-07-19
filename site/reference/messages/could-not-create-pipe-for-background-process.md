---
message: "could not create pipe for background process: %m"
slug: could-not-create-pipe-for-background-process
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:643"
reproduced: false
---

# `could not create pipe for background process: %m`

## What it means

`pg_basebackup` could not create the pipe its background WAL-streaming process uses to communicate. The `%m` reason gives the OS error.

## When it happens

It happens when `pg_basebackup` starts background streaming and pipe creation fails, usually from file-descriptor exhaustion.

## How to fix

Check the host's file-descriptor limits (`ulimit -n`) and reduce concurrent load, then rerun the backup.

## Example

*Illustrative* — pipe creation failing for the background streamer.

```text
pg_basebackup: fatal: could not create pipe for background process: Too many open files
```

## Related

- [could not create background process](./could-not-create-background-process.md)
- [could not create communication channels](./could-not-create-communication-channels.md)
