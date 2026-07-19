---
message: "could not get result of cancel request: %s"
slug: could-not-get-result-of-cancel-request
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/contrib/postgres_fdw/connection.c:1631"
  - "postgres/contrib/postgres_fdw/connection.c:1646"
reproduced: false
---

# `could not get result of cancel request: %s`

## What it means

A warning that a client tool sent a query-cancel request but could not obtain the result of that request; the detail gives the connection-level reason.

## When it happens

It arises in tools (and libpq-based programs) when a cancel is issued and the follow-up fails — usually because the connection to the server was already lost.

## Is this a problem?

Usually harmless — the target query often ended anyway. If cancellation matters, verify the connection is alive before cancelling; a lost connection is the common cause named in the detail.

## Example

*Illustrative* — a cancel request without a result.

```text
WARNING:  could not get result of cancel request: server closed the connection unexpectedly
```

## Related

- [could not create SSL context: %s](./could-not-create-ssl-context.md)
- [pg_getnameinfo_all() failed: %s](./pg-getnameinfo-all-failed.md)
