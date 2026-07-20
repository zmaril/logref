---
message: "expected password response, got message type %d"
slug: expected-password-response-got-message-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/auth.c:731"
reproduced: false
---

# `expected password response, got message type %d`

## What it means

During password authentication the server expected the client's password-response message and received a different protocol message type. The placeholder is the message-type byte it got.

## When it happens

It fires mid-handshake when a client sends an out-of-sequence message where a password response was required — usually a client library that mishandles the authentication exchange, a proxy that rewrites the stream, or a corrupted connection.

## How to fix

Confirm the client library implements the requested password method (`password`, `md5`, or `scram-sha-256`) and is configured to send credentials. Remove any proxy that interferes with the startup exchange. Align `pg_hba.conf` with what the client can do so the negotiated method matches.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected password response, got message type 88
```

## Related

- [expected SASL response, got message type](./expected-sasl-response-got-message-type.md)
- [expected GSS response, got message type](./expected-gss-response-got-message-type.md)
