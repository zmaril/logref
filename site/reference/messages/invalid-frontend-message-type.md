---
message: "invalid frontend message type %d"
slug: invalid-frontend-message-type
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:467"
  - "postgres/src/backend/tcop/postgres.c:5201"
reproduced: false
---

# `invalid frontend message type %d`

## What it means

The server read a protocol message from a client whose leading message-type byte is not one it recognizes for the current connection state. The connection is protocol-broken, so the backend terminates it.

## When it happens

It arises when a non-Postgres client speaks to the port, a client library sends a malformed or out-of-sequence message, a proxy corrupts the stream, or an SSL/TLS negotiation is mishandled so plaintext is read as protocol.

## How to fix

Point genuine Postgres clients at the port and confirm nothing else (a health checker, a port scanner, or the wrong service) is connecting. If a custom client or proxy is involved, verify it implements the frontend/backend protocol and TLS handshake correctly. The placeholder shows the unexpected byte, which can hint at what was sent.

## Example

*Illustrative* — a non-protocol byte where a message type was expected.

```text
FATAL:  invalid frontend message type 71
```

## Related

- [invalid message length](./invalid-message-length.md)
- [invalid string in message](./invalid-string-in-message.md)
