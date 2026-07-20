---
message: "could not close postmaster death monitoring pipe in child process: %m"
slug: could-not-close-postmaster-death-monitoring-pipe-in-child-process
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:1898"
reproduced: false
---

# `could not close postmaster death monitoring pipe in child process: %m`

## What it means

A newly forked backend could not close its copy of the pipe the postmaster uses to detect its own death. The `%m` reason gives the OS error. This is a low-level file-descriptor operation in the child process right after fork.

## When it happens

It fires in a child process during startup, when closing the inherited postmaster-death pipe descriptor fails. In practice this only happens under severe file-descriptor exhaustion or kernel-level trouble.

## How to fix

Treat it as a sign the host is out of file descriptors or otherwise unhealthy. Check the OS file-descriptor limits and the system log for resource pressure, then restart the server once the host is stable.

## Example

*Illustrative* — the child process fails to close the inherited pipe.

```text
FATAL:  could not close postmaster death monitoring pipe in child process: Bad file descriptor
```

## Related

- [could not create pipe to monitor postmaster death](./could-not-create-pipe-to-monitor-postmaster-death.md)
- [could not create background process](./could-not-create-background-process.md)
