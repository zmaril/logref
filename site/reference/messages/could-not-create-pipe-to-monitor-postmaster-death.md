---
message: "could not create pipe to monitor postmaster death: %m"
slug: could-not-create-pipe-to-monitor-postmaster-death
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:4710"
reproduced: false
---

# `could not create pipe to monitor postmaster death: %m`

## What it means

The postmaster could not create the pipe backends use to detect its death. The `%m` reason gives the OS error. This pipe lets child processes notice at once if the postmaster exits.

## When it happens

It happens at server startup when the pipe cannot be created, usually from file-descriptor exhaustion on the host.

## How to fix

Check the host's file-descriptor limits and overall resource health, free up descriptors, and restart the server.

## Example

*Illustrative* — the death-monitoring pipe failing to create.

```text
FATAL:  could not create pipe to monitor postmaster death: Too many open files
```

## Related

- [could not close postmaster death monitoring pipe in child process](./could-not-close-postmaster-death-monitoring-pipe-in-child-process.md)
- [could not create lock file](./could-not-create-lock-file.md)
