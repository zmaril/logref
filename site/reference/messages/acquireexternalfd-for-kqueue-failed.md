---
message: "AcquireExternalFD, for kqueue, failed: %m"
slug: acquireexternalfd-for-kqueue-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/waiteventset.c:437"
reproduced: false
---

# `AcquireExternalFD, for kqueue, failed: %m`

## What it means

The server tried to reserve a file descriptor for a `kqueue` instance and the underlying `kqueue()` call failed, so it could not create the event-polling object it needed.

## When it happens

It occurs on BSD/macOS platforms when the server creates a kqueue and the operating system refuses, typically because the file-descriptor limit is exhausted.

## How to fix

Read the errno text at the end of the message. It is usually descriptor exhaustion: raise the process file-descriptor limit, adjust `max_files_per_process`, and reduce descriptor use by other processes on the host.

## Example

*Illustrative* — kqueue creation failing on descriptor exhaustion.

```text
ERROR:  AcquireExternalFD, for kqueue, failed: Too many open files
```

## Related

- [AcquireExternalFD, for epoll_create1, failed](./acquireexternalfd-for-epoll-create1-failed.md)
- [all AuxiliaryProcs are in use](./all-auxiliaryprocs-are-in-use.md)
