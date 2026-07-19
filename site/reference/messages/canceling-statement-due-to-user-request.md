---
message: "canceling statement due to user request"
slug: canceling-statement-due-to-user-request
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_QUERY_CANCELED
    code: "57014"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:3634"
reproduced: false
---

# `canceling statement due to user request`

## What it means

The statement was canceled because someone asked the backend to cancel it. This is the normal result of an explicit cancel request rather than a fault in the query.

## When it happens

It occurs after a client sends a cancel — for example pressing Ctrl-C in `psql` — or when another session calls `pg_cancel_backend()` on the running query's process.

## How to fix

This is expected when a cancel was intended. If a query is being canceled without anyone meaning to, look for a client library or connection-pool timeout, a monitoring tool, or an administrator calling `pg_cancel_backend()`, and adjust that source.

## Example

*Illustrative* — an explicit cancel.

```text
ERROR:  canceling statement due to user request
```

## Related

- [canceling statement due to statement timeout](./canceling-statement-due-to-statement-timeout.md)
- [canceling authentication due to timeout](./canceling-authentication-due-to-timeout.md)
