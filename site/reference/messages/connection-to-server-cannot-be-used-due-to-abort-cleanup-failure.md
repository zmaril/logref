---
message: "connection to server \"%s\" cannot be used due to abort cleanup failure"
slug: connection-to-server-cannot-be-used-due-to-abort-cleanup-failure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_EXCEPTION
    code: "08000"
call_sites:
  - "postgres/contrib/postgres_fdw/connection.c:1509"
reproduced: false
---

# `connection to server "%s" cannot be used due to abort cleanup failure`

## What it means

`postgres_fdw` marked a remote connection unusable because a prior transaction abort could not be cleaned up on the remote side. To stay safe, the connection is not reused until it is re-established.

## When it happens

It happens on subsequent use of a `postgres_fdw` connection after an earlier remote transaction failed to roll back cleanly (for example the remote server became unreachable during abort).

## How to fix

The FDW will discard and reopen the connection; retry the operation. If it persists, check the remote server's health and network, and consider tuning `postgres_fdw` connection handling. The immediate cause is a failed remote cleanup, so ensure the remote is reachable and healthy.

## Example

*Illustrative* — a poisoned FDW connection after a failed abort.

```text
ERROR:  connection to server "remote1" cannot be used due to abort cleanup failure
```

## Related

- [connection not available](./connection-not-available-a78858.md)
- [connection to server was lost](./connection-to-server-was-lost.md)
