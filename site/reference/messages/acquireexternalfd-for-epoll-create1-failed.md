---
message: "AcquireExternalFD, for epoll_create1, failed: %m"
slug: acquireexternalfd-for-epoll-create1-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/waiteventset.c:428"
reproduced: false
---

# `AcquireExternalFD, for epoll_create1, failed: %m`

## What it means

The server tried to reserve a file descriptor for an `epoll` instance and the underlying `epoll_create1()` call failed, so it could not create the event-polling object it needed.

## When it happens

It occurs on Linux when the server creates an epoll set (for example for its event-loop machinery) and the operating system refuses, usually because the process or system file-descriptor limit is exhausted.

## How to fix

Read the errno text at the end of the message. Most often it is too many open files: raise the process file-descriptor limit (`ulimit -n`, systemd `LimitNOFILE`) and the server's `max_files_per_process`, and reduce descriptor pressure from other software on the host.

## Example

*Illustrative* — epoll creation failing on descriptor exhaustion.

```text
ERROR:  AcquireExternalFD, for epoll_create1, failed: Too many open files
```

## Related

- [AcquireExternalFD, for kqueue, failed](./acquireexternalfd-for-kqueue-failed.md)
- [all AuxiliaryProcs are in use](./all-auxiliaryprocs-are-in-use.md)
