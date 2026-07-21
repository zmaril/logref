---
message: "epoll_create1 failed: %m"
slug: epoll-create1-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/waiteventset.c:433"
reproduced: false
---

# `epoll_create1 failed: %m`

## What it means

An internal wait-event guard. The server's `epoll_create1` system call failed while building an event set to wait on file descriptors. The placeholder is the OS error. It usually reflects an OS resource limit.

## When it happens

It fires when a backend sets up an epoll-based wait event set and the kernel refuses, most often because the process hit its open-file-descriptor limit.

## How to fix

Check the OS error text. `Too many open files` means the per-process file-descriptor limit is exhausted — raise `ulimit -n`/`LimitNOFILE` for the server, and review `max_files_per_process`. Other errors point at broader kernel resource pressure.

## Example

*Illustrative* — epoll setup failing on a limit.

```text
ERROR:  epoll_create1 failed: Too many open files
```

## Related

- [entry ref vanished before deletion](./entry-ref-vanished-before-deletion.md)
- [dynamic shared memory control segment is not valid](./dynamic-shared-memory-control-segment-is-not-valid.md)
