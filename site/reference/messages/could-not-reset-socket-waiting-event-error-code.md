---
message: "could not reset socket waiting event: error code %lu"
slug: could-not-reset-socket-waiting-event-error-code
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/port/win32/socket.c:199"
reproduced: false
---

# `could not reset socket waiting event: error code %lu`

## What it means

On Windows, the server could not reset the event object it associates with a socket for waiting. The trailing text is the Windows error code. These event objects let the wait machinery watch sockets on Windows.

## When it happens

It fires inside the Windows socket layer while the server manages the readiness event for a connection, when the reset call on that event fails.

## How to fix

This is a low-level Windows socket failure and is not caused by anything a query did. It usually accompanies a connection that is going away or an OS resource problem. Check for handle exhaustion or unusual network conditions on the host, and capture the error code if it recurs on a healthy system.

## Example

*Illustrative* — resetting a socket event failed on Windows.

```text
ERROR:  could not reset socket waiting event: error code 6
```

## Related

- [could not register process for wait](./could-not-register-process-for-wait-error-code.md)
- [could not set socket to nonblocking mode](./could-not-set-socket-to-nonblocking-mode.md)
