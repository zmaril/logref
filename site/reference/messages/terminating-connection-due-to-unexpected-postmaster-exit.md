---
message: "terminating connection due to unexpected postmaster exit"
slug: terminating-connection-due-to-unexpected-postmaster-exit
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_ADMIN_SHUTDOWN
    code: "57P01"
call_sites:
  - "postgres/src/backend/access/transam/xlogfuncs.c:757"
  - "postgres/src/backend/access/transam/xlogwait.c:473"
reproduced: false
---

# `terminating connection due to unexpected postmaster exit`

## What it means

A backend terminated its own connection because the postmaster (the main server process) exited unexpectedly. Without the postmaster, backends cannot safely continue, so they shut down.

## When it happens

It arises when the postmaster crashes or is killed (for example by the OOM killer or a forced signal) while backends are running. Every child backend then exits with this message.

## How to fix

Find why the postmaster died: check the server log and the OS logs for a crash, signal, or out-of-memory kill of the main process. Address the root cause (memory pressure, a crash bug, or an administrative kill), then restart the server cleanly.

## Example

*Illustrative* — backends exiting after the postmaster died.

```text
FATAL:  terminating connection due to unexpected postmaster exit
```

## Related

- [perhaps the backend died while processing](./perhaps-the-backend-died-while-processing.md)
- [terminating connection due to conflict with recovery](./terminating-connection-due-to-conflict-with-recovery.md)
