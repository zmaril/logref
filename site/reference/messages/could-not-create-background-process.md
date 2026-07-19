---
message: "could not create background process: %m"
slug: could-not-create-background-process
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:730"
reproduced: false
---

# `could not create background process: %m`

## What it means

`pg_basebackup` could not spawn the background process it uses to stream WAL alongside the base backup. The `%m` reason gives the OS error.

## When it happens

It happens when `pg_basebackup` starts with background WAL streaming and the `fork` (or equivalent) fails, usually from process-count or memory limits on the host.

## How to fix

Check the host's process and memory limits (`ulimit -u`, available memory). Reduce concurrent load or raise the limits, then rerun the backup.

## Example

*Illustrative* — the background streamer failing to start.

```text
pg_basebackup: fatal: could not create background process: Resource temporarily unavailable
```

## Related

- [could not create background thread](./could-not-create-background-thread.md)
- [could not create pipe for background process](./could-not-create-pipe-for-background-process.md)
