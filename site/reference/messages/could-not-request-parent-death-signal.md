---
message: "could not request parent death signal: %m"
slug: could-not-request-parent-death-signal
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/pmsignal.c:417"
  - "postgres/src/backend/storage/ipc/pmsignal.c:420"
reproduced: false
---

# `could not request parent death signal: %m`

## What it means

Internal error. A child process could not ask the kernel to signal it when its parent (the postmaster) dies. The `%m` is the operating-system error. It is a platform-support guard.

## When it happens

The parent-death-signal request (a Linux `prctl` or the platform equivalent) failed while a background process initialized. It is rare and platform-specific.

## How to fix

This is a low-level startup guard. Check the platform and kernel support for the parent-death signal, and capture the OS error. If it recurs on a supported platform, report it with the environment details.

## Example

*Illustrative* — the parent-death-signal request failed.

```text
ERROR:  could not request parent death signal: Invalid argument
```

## Related

- [could not start background process](./could-not-start-background-process.md)
- [fcntl(F_SETFD) failed on socket](./fcntl-f-setfd-failed-on-socket.md)
