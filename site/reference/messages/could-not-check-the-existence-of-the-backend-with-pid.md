---
message: "could not check the existence of the backend with PID %d: %m"
slug: could-not-check-the-existence-of-the-backend-with-pid
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/storage/ipc/signalfuncs.c:196"
reproduced: false
---

# `could not check the existence of the backend with PID %d: %m`

## What it means

A function that checks whether a backend process is alive (by PID) failed to query the process's existence. The `%m` reason gives the OS error. The check could not be completed.

## When it happens

It happens in signal/monitoring functions (such as those behind `pg_terminate_backend` or backend-existence checks) when the underlying OS call to test the process fails.

## How to fix

Read the OS reason in the message. This is usually an environment-level issue (permissions or an unusual process state). Verify the PID is valid and that the server has the OS privileges to signal or inspect processes; retry once the cause is addressed.

## Example

*Illustrative* — a failed backend-existence check.

```text
ERROR:  could not check the existence of the backend with PID 12345: ...
```

## Related

- [could not append BufFile with non-matching resource owner](./could-not-append-buffile-with-non-matching-resource-owner.md)
- [connection to client lost](./connection-to-client-lost.md)
