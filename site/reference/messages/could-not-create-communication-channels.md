---
message: "could not create communication channels: %m"
slug: could-not-create-communication-channels
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:957"
reproduced: false
---

# `could not create communication channels: %m`

## What it means

A parallel `pg_dump` could not set up the pipes or sockets its worker processes use to talk to the leader. The `%m` reason gives the OS error.

## When it happens

It happens when `pg_dump -j` starts and the OS refuses to create the inter-process communication channels, usually from file-descriptor or resource limits.

## How to fix

Check the host's file-descriptor and process limits. Lower the parallelism (`-j`) or raise the limits, then rerun the dump.

## Example

*Illustrative* — parallel dump channel setup failing.

```text
pg_dump: fatal: could not create communication channels: Too many open files
```

## Related

- [could not create pipe for background process](./could-not-create-pipe-for-background-process.md)
- [could not create thread](./could-not-create-thread.md)
