---
message: "expected SASL response, got message type %d"
slug: expected-sasl-response-got-message-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/auth-sasl.c:93"
reproduced: false
---

# `expected SASL response, got message type %d`

## What it means

During SASL (SCRAM) authentication the server expected the client's SASL response message and received a different protocol message type. The placeholder is the message-type byte it got.

## When it happens

It fires mid-handshake when a client negotiating `scram-sha-256` sends an out-of-sequence message — commonly a client library that does not fully support SCRAM, a proxy that rewrites the stream, or a corrupted connection.

## How to fix

Confirm the client library supports SCRAM (`scram-sha-256`) authentication and is up to date. Remove any proxy that alters the authentication exchange. If the client cannot do SCRAM, adjust `pg_hba.conf` and the stored password encryption to a method the client supports.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected SASL response, got message type 88
```

## Related

- [expected password response, got message type](./expected-password-response-got-message-type.md)
- [expected SSPI response, got message type](./expected-sspi-response-got-message-type.md)
