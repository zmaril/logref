---
message: "expected SSPI response, got message type %d"
slug: expected-sspi-response-got-message-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/auth.c:1297"
reproduced: false
---

# `expected SSPI response, got message type %d`

## What it means

During SSPI authentication (the Windows negotiation path) the server expected the client's SSPI response message and received a different protocol message type. The placeholder is the message-type byte it got.

## When it happens

It fires mid-handshake against an SSPI-configured server when a client sends an out-of-sequence message — usually a client that does not implement SSPI/negotiate correctly, or a proxy or connection that disrupts the exchange.

## How to fix

Check that the client supports SSPI/negotiate authentication against this server and is configured for it. Remove any proxy interfering with the startup sequence. If the client should not use SSPI, adjust `pg_hba.conf` so the negotiated method matches what the client can do.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected SSPI response, got message type 88
```

## Related

- [expected GSS response, got message type](./expected-gss-response-got-message-type.md)
- [expected SASL response, got message type](./expected-sasl-response-got-message-type.md)
