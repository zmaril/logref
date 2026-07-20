---
message: "before_shmem_exit has been called prematurely"
slug: before-shmem-exit-has-been-called-prematurely
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/storage/ipc/ipc.c:442"
reproduced: false
---

# `before_shmem_exit has been called prematurely`

## What it means

A shutdown callback that must run only during normal process exit was invoked at the wrong time. The `before_shmem_exit` callbacks clean up before shared memory is detached, and one ran out of sequence.

## When it happens

It is an internal ordering guard in process teardown. It would only appear from a bug in how a subsystem or extension registers or triggers exit callbacks.

## How to fix

There is no user-facing fix. If it appears, note any extensions that register process-exit or shared-memory hooks, capture the surrounding log, and report it with the server version.

## Example

*Illustrative* — the exit-ordering guard.

```text
FATAL:  before_shmem_exit has been called prematurely
```

## Related

- [auxiliaryprockill called in child process](./auxiliaryprockill-called-in-child-process.md)
- [begininternalsubtransaction unexpected state](./begininternalsubtransaction-unexpected-state.md)
