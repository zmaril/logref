---
message: "munmap(%p, %zu) failed: %m"
slug: munmap-failed-7c74ce
passthrough: false
api: [elog]
level: [LOG]
call_sites:
  - "postgres/src/backend/port/sysv_shmem.c:683"
  - "postgres/src/backend/port/sysv_shmem.c:989"
reproduced: false
---

# `munmap(%p, %zu) failed: %m`

## What it means

A log message that a `munmap` call (releasing a memory mapping) failed; the errno string gives the operating-system reason.

## When it happens

It arises during teardown of a memory-mapped region (for example shared memory) when the unmap call fails — a rare operating-system condition, often at shutdown.

## Is this a problem?

This is usually a harmless cleanup anomaly. If it recurs during normal operation, check for operating-system memory-mapping problems; the errno in the message is the primary clue.

## Example

*Illustrative* — a failed munmap.

```text
LOG:  munmap(0x7f0012340000, 8388608) failed: Invalid argument
```

## Related

- [could not resize shared memory segment "%s" to %zu bytes: %m](./could-not-resize-shared-memory-segment-to-bytes.md)
- [could not close listen socket: %m](./could-not-close-listen-socket.md)
