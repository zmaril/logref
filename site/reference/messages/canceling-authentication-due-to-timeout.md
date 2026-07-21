---
message: "canceling authentication due to timeout"
slug: canceling-authentication-due-to-timeout
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_QUERY_CANCELED
    code: "57014"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:3478"
reproduced: false
---

# `canceling authentication due to timeout`

## What it means

A connection did not complete authentication within `authentication_timeout`, so the server closed it. Authentication must finish inside that window to protect against connections that stall before logging in.

## When it happens

It occurs when the client is slow to send authentication responses, when an external auth service (LDAP, Kerberos, RADIUS) is slow or unreachable, or when the network delays the handshake.

## How to fix

Find why authentication stalled: check the client's ability to respond, the reachability and latency of any external authentication service, and the network path. Raise `authentication_timeout` only if slow but healthy auth is expected; otherwise fix the underlying delay.

## Example

*Illustrative* — a login that stalled past the timeout.

```text
FATAL:  canceling authentication due to timeout
```

## Related

- [canceling statement due to statement timeout](./canceling-statement-due-to-statement-timeout.md)
- [canceling statement due to user request](./canceling-statement-due-to-user-request.md)
