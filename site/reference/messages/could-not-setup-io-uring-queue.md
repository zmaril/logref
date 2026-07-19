---
message: "could not setup io_uring queue: %m"
slug: could-not-setup-io-uring-queue
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/aio/method_io_uring.c:396"
reproduced: false
---

# `could not setup io_uring queue: %m`

## What it means

The server could not create an io_uring queue. The trailing text is the operating-system error. io_uring is a Linux asynchronous-I/O interface the server can use when `io_method` is set to it.

## When it happens

It fires at startup or when initializing asynchronous I/O, when the kernel refuses to set up the io_uring instance — often because io_uring is disabled or restricted, or a per-process limit was reached.

## How to fix

Check whether io_uring is available and permitted on the host: some kernels or security policies disable it. Raise the relevant limits (such as locked-memory limits) if they are the cause, or set `io_method` to `worker` or `sync` to use a different I/O path. The OS error names the specific restriction.

## Example

*Illustrative* — the io_uring queue could not be created.

```text
ERROR:  could not setup io_uring queue: Operation not permitted
```

## Related

- [couldn't find a free worker ID](./couldn-t-find-a-free-worker-id.md)
- [could not start reading blocks in file](./could-not-start-reading-blocks-in-file.md)
