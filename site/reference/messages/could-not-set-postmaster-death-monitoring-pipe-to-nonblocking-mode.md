---
message: "could not set postmaster death monitoring pipe to nonblocking mode: %m"
slug: could-not-set-postmaster-death-monitoring-pipe-to-nonblocking-mode
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:4723"
reproduced: false
---

# `could not set postmaster death monitoring pipe to nonblocking mode: %m`

## What it means

The server could not put the postmaster death-monitoring pipe into nonblocking mode. The trailing text is the operating-system error. Nonblocking mode lets the server poll the pipe without stalling.

## When it happens

It fires during startup when the server configures the death pipe and the call to make its descriptor nonblocking fails.

## How to fix

This is a low-level startup failure rather than a user error. It usually points at descriptor exhaustion or an unusual environment. Check the host's file-descriptor limits and the surrounding log, and report it with details if it recurs on a healthy host.

## Example

*Illustrative* — setting nonblocking mode on the death pipe failed.

```text
FATAL:  could not set postmaster death monitoring pipe to nonblocking mode: Too many open files
```

## Related

- [could not set postmaster death monitoring pipe to FD_CLOEXEC mode](./could-not-set-postmaster-death-monitoring-pipe-to-fd-cloexec-mode.md)
- [could not set socket to nonblocking mode](./could-not-set-socket-to-nonblocking-mode.md)
