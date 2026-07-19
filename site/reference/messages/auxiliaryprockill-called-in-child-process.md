---
message: "AuxiliaryProcKill() called in child process"
slug: auxiliaryprockill-called-in-child-process
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/storage/lmgr/proc.c:1105"
reproduced: false
---

# `AuxiliaryProcKill() called in child process`

## What it means

The auxiliary-process cleanup routine was invoked from a process that is not the auxiliary process it belongs to. This is a fatal internal invariant about which process owns the auxiliary-process slot.

## When it happens

It is a can't-happen guard in process teardown. It would only appear from a serious bug in process management, not from any SQL or configuration.

## How to fix

There is no user action. If you encounter it, capture the surrounding log context and server version and report it to the Postgres developers, along with any extensions that create background or auxiliary processes.

## Example

*Illustrative* — the guard during process exit.

```text
PANIC:  AuxiliaryProcKill() called in child process
```

## Related

- [before_shmem_exit has been called prematurely](./before-shmem-exit-has-been-called-prematurely.md)
- [background process terminated unexpectedly](./background-process-terminated-unexpectedly.md)
