---
message: "failed to send signal to postmaster: %m"
slug: failed-to-send-signal-to-postmaster
passthrough: false
api: [ereport]
level: [ERROR, WARNING]
sqlstate:
  - symbol: ERRCODE_SYSTEM_ERROR
    code: "58000"
call_sites:
  - "postgres/src/backend/access/transam/xlogfuncs.c:725"
  - "postgres/src/backend/storage/ipc/signalfuncs.c:290"
reproduced: false
---

# `failed to send signal to postmaster: %m`

## What it means

A process could not deliver a signal to the postmaster. The `%m` is the operating-system error. It fires from functions such as `pg_reload_conf()`/`pg_rotate_logfile()` or internal signaling. Severity is WARNING or ERROR by site.

## When it happens

The postmaster PID was stale, the process lacked permission to signal it, or the postmaster was gone, when a backend tried to notify it.

## How to fix

Confirm the postmaster is running and that `postmaster.pid` is current. If the file is stale or the server was restarted under a different PID, the signal target is wrong — reconnect to the live server.

## Example

*Illustrative* — signaling the postmaster failed.

```text
WARNING:  failed to send signal to postmaster: No such process
```

## Related

- [could not request parent death signal](./could-not-request-parent-death-signal.md)
- [getrlimit failed](./getrlimit-failed.md)
