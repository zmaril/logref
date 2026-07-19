---
message: "connection to server was lost"
slug: connection-to-server-was-lost
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/common.c:365"
reproduced: false
---

# `connection to server was lost`

## What it means

psql lost its connection to the server while running. The session's link to the backend is gone, so the current command cannot complete.

## When it happens

It happens in psql when the backend terminates (crash, forced disconnect, admin shutdown) or the network connection drops during a command.

## How to fix

Reconnect with `\c` and retry. Investigate why the backend went away — check the server log for crashes or terminations, look for `OOM`/killer activity, and verify network stability. Repeated losses warrant checking server health.

## Example

*Illustrative* — psql losing the server connection.

```text
psql: error: connection to server was lost
```

## Related

- [connection to client lost](./connection-to-client-lost.md)
- [\connect](./connect.md)
