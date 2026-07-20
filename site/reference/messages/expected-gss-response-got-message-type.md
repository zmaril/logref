---
message: "expected GSS response, got message type %d"
slug: expected-gss-response-got-message-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/auth.c:1019"
reproduced: false
---

# `expected GSS response, got message type %d`

## What it means

During GSSAPI authentication the server expected the client's GSS response message and received a different protocol message type instead. The placeholder is the message-type byte it got.

## When it happens

It fires mid-handshake when a client speaking to a GSSAPI-configured server sends an out-of-sequence message — usually a client that does not implement GSSAPI correctly, a proxy that rewrites the protocol stream, or a corrupted connection.

## How to fix

Check that the client library supports GSSAPI and is configured to use it against this server. Remove or fix any proxy that tampers with the startup packet sequence. Confirm the connection is not being disrupted. If the client should not use GSSAPI, adjust `pg_hba.conf` or the client so the negotiated method matches.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected GSS response, got message type 88
```

## Related

- [expected SASL response, got message type](./expected-sasl-response-got-message-type.md)
- [expected password response, got message type](./expected-password-response-got-message-type.md)
