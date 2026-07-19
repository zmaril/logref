---
message: "fcntl(F_SETFD) failed on socket: %m"
slug: fcntl-f-setfd-failed-on-socket
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:305"
  - "postgres/src/backend/libpq/pqcomm.c:555"
reproduced: false
---

# `fcntl(F_SETFD) failed on socket: %m`

## What it means

Setting the close-on-exec flag on a socket with `fcntl(F_SETFD)` failed. The `%m` is the operating-system error. It fires while the server prepares a listening or connection socket during startup.

## When it happens

A descriptor operation failed under resource pressure or an unusual environment while the server set up sockets. It is a low-level startup guard.

## How to fix

Check descriptor limits and the process environment. This is rare on a healthy host; if it recurs, capture the OS error and the platform and report it.

## Example

*Illustrative* — F_SETFD failed on a socket.

```text
FATAL:  fcntl(F_SETFD) failed on socket: Bad file descriptor
```

## Related

- [could not request parent death signal](./could-not-request-parent-death-signal.md)
- [getrlimit failed](./getrlimit-failed.md)
