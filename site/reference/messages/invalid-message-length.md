---
message: "invalid message length"
slug: invalid-message-length
passthrough: false
api: [elog, ereport]
level: [COMMERROR, ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:1225"
  - "postgres/src/backend/replication/logical/applyparallelworker.c:778"
reproduced: false
---

# `invalid message length`

## What it means

A protocol message declared a length that is impossible for its type — too short to contain the required fields, or inconsistent with what follows. The server treats the connection as protocol-broken.

## When it happens

It arises when a client library sends a malformed message, a proxy or network layer corrupts the byte stream, or a non-Postgres client speaks to the port. It can also follow an earlier protocol desync.

## How to fix

Verify that only genuine, correctly implemented Postgres clients connect, and that any proxy in the path preserves the byte stream. If a custom client encodes messages, check its length fields. Persistent occurrences from one source point at that client or an unstable network path.

## Example

*Illustrative* — a message with an impossible length header.

```text
ERROR:  invalid message length
```

## Related

- [invalid frontend message type](./invalid-frontend-message-type.md)
- [invalid string in message](./invalid-string-in-message.md)
