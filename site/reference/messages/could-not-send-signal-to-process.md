---
message: "could not send signal to process %d: %m"
slug: could-not-send-signal-to-process
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/src/backend/storage/ipc/signalfuncs.c:120"
  - "postgres/src/backend/storage/lmgr/proc.c:1616"
  - "postgres/src/backend/utils/adt/mcxtfuncs.c:304"
reproduced: false
---

# `could not send signal to process %d: %m`

## What it means

The server tried to send an operating-system signal to another backend process and the send failed. It reports the OS error. Raised as a warning, it means the signal — used to cancel, terminate, or notify — did not reach its target.

## When it happens

Calling a function such as `pg_cancel_backend` or `pg_terminate_backend`, or internal signalling, when the target process had already exited or the signal could not be delivered. A process that ended between lookup and signal is the usual benign cause.

## Is this a problem?

Often benign: the target process likely exited already, so there was nothing to signal. Read the system error detail to confirm. If it recurs against processes that should exist, investigate process permissions and the OS signalling path.

## Example

*Illustrative* — signalling a process that has gone.

```text
WARNING:  could not send signal to process 12345: No such process
```

## Related

- [permission denied to cancel query](./permission-denied-to-cancel-query.md)
- [could not send stop signal pid](./could-not-send-stop-signal-pid.md)
