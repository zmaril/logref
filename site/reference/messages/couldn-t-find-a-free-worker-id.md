---
message: "couldn't find a free worker ID"
slug: couldn-t-find-a-free-worker-id
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/aio/method_worker.c:590"
reproduced: false
---

# `couldn't find a free worker ID`

## What it means

The asynchronous-I/O worker subsystem could not find a free slot to assign a new worker. Each I/O worker occupies a numbered slot up to a configured maximum, and all slots were in use.

## When it happens

It fires when the server starts an I/O worker and the pool of worker IDs is exhausted. On a correctly configured server this pool is sized to the maximum, so reaching it points at an accounting inconsistency rather than normal load.

## How to fix

This is an internal guard. It is not something a query causes and should not be reachable under normal operation. If it appears, capture the surrounding log and the `io_workers` setting and report it. Restarting the server clears the worker state.

## Example

*Illustrative* — no free I/O worker slot.

```text
ERROR:  couldn't find a free worker ID
```

## Related

- [could not setup io_uring queue](./could-not-setup-io-uring-queue.md)
- [could not start reading blocks in file](./could-not-start-reading-blocks-in-file.md)
