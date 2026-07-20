---
message: "client selected an invalid SASL authentication mechanism"
slug: client-selected-an-invalid-sasl-authentication-mechanism
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/auth-oauth.c:114"
  - "postgres/src/backend/libpq/auth-scram.c:263"
reproduced: false
---

# `client selected an invalid SASL authentication mechanism`

## What it means

During authentication, the client asked for a SASL mechanism the server does not offer or support in this context. SASL underlies SCRAM and OAuth authentication; the client's chosen mechanism name did not match one the server advertised.

## When it happens

A client library requesting a SASL mechanism the server is not configured for — a driver/server version mismatch, a client attempting a mechanism the `pg_hba.conf` method does not permit, or a malformed authentication exchange.

## How to fix

Ensure the client and server agree on the authentication method: use a client library that supports the server's configured SCRAM/OAuth mechanism, and confirm `pg_hba.conf` specifies the intended method. Upgrade an outdated client driver if it lacks the required SASL mechanism.

## Example

*Illustrative* — a client offering an unsupported SASL mechanism.

```text
ERROR:  client selected an invalid SASL authentication mechanism
```

## Related

- [client uses authorization identity, but it is not supported](./client-uses-authorization-identity-but-it-is-not-supported.md)
- [could not accept SSL connection: EOF detected](./could-not-accept-ssl-connection-eof-detected.md)
