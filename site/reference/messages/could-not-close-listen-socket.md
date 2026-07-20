---
message: "could not close listen socket: %m"
slug: could-not-close-listen-socket
passthrough: false
api: [elog]
level: [LOG]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:1443"
  - "postgres/src/backend/postmaster/postmaster.c:1919"
reproduced: false
---

# `could not close listen socket: %m`

## What it means

The server could not close one of its listening sockets during shutdown or reconfiguration; the errno string gives the operating-system reason.

## When it happens

It arises when the postmaster tears down listen sockets (at shutdown, or when reloading a changed `listen_addresses`) and the close call fails.

## Is this a problem?

This is usually a harmless cleanup anomaly. If it recurs, check for operating-system socket or file-descriptor issues; the errno in the message is the primary clue.

## Example

*Illustrative* — a failed listen-socket close.

```text
LOG:  could not close listen socket: Bad file descriptor
```

## Related

- [could not read from logger pipe: %m](./could-not-read-from-logger-pipe.md)
- [munmap(%p, %zu) failed: %m](./munmap-failed-7c74ce.md)
