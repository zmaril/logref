---
message: "could not set socket to nonblocking mode: %m"
slug: could-not-set-socket-to-nonblocking-mode
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:297"
reproduced: false
---

# `could not set socket to nonblocking mode: %m`

## What it means

The server could not put a client socket into nonblocking mode. The trailing text is the operating-system error. Nonblocking sockets let the server multiplex many connections without stalling on any one.

## When it happens

It fires while the server sets up a connection's socket and the call to make it nonblocking fails — typically an OS resource problem such as descriptor exhaustion.

## How to fix

This is an OS-level failure on the connection socket, not a query problem. Check the host's file-descriptor and socket limits and whether the system is under resource pressure. Look at the surrounding log for what the server was doing, and raise limits if the host is running out of descriptors.

## Example

*Illustrative* — a socket could not be made nonblocking.

```text
FATAL:  could not set socket to nonblocking mode: Too many open files
```

## Related

- [could not reset socket waiting event](./could-not-reset-socket-waiting-event-error-code.md)
- [could not send data to client](./could-not-send-data-to-client.md)
