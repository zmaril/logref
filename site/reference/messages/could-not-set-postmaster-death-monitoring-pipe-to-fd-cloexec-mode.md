---
message: "could not set postmaster death monitoring pipe to FD_CLOEXEC mode: %m"
slug: could-not-set-postmaster-death-monitoring-pipe-to-fd-cloexec-mode
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:164"
reproduced: false
---

# `could not set postmaster death monitoring pipe to FD_CLOEXEC mode: %m`

## What it means

The server could not put the postmaster death-monitoring pipe into close-on-exec mode. The trailing text is the operating-system error. That pipe lets backends notice immediately if the postmaster dies.

## When it happens

It fires early in startup when the server configures the death pipe's file descriptor and the call to set the close-on-exec flag fails.

## How to fix

This is an OS-level failure at startup, not a configuration mistake. It usually indicates file-descriptor exhaustion or an unusual restricted environment. Check the host's descriptor limits and the surrounding log, and capture details if it persists on a normal host.

## Example

*Illustrative* — setting close-on-exec on the death pipe failed.

```text
FATAL:  could not set postmaster death monitoring pipe to FD_CLOEXEC mode: Too many open files
```

## Related

- [could not set postmaster death monitoring pipe to nonblocking mode](./could-not-set-postmaster-death-monitoring-pipe-to-nonblocking-mode.md)
- [could not set socket to nonblocking mode](./could-not-set-socket-to-nonblocking-mode.md)
