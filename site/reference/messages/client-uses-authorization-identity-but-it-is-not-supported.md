---
message: "client uses authorization identity, but it is not supported"
slug: client-uses-authorization-identity-but-it-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/libpq/auth-oauth.c:271"
  - "postgres/src/backend/libpq/auth-scram.c:1071"
reproduced: false
---

# `client uses authorization identity, but it is not supported`

## What it means

During SASL authentication, the client supplied an authorization identity (a request to act as a different user than the one authenticating), which Postgres does not support. The SCRAM and OAuth exchanges here do not implement authzid.

## When it happens

A client library that sends a non-empty SASL authorization identity during SCRAM or OAuth authentication, usually from a generic SASL implementation that populates the field.

## How to fix

Configure the client not to send an authorization identity; the login user must be the same as the authenticated user. If the driver exposes an authzid option, leave it empty. Report the client library if it sends authzid unconditionally against Postgres.

## Example

*Illustrative* — a client sending an authorization identity.

```text
ERROR:  client uses authorization identity, but it is not supported
```

## Related

- [client selected an invalid SASL authentication mechanism](./client-selected-an-invalid-sasl-authentication-mechanism.md)
- [could not encode SCRAM client key](./could-not-encode-scram-client-key.md)
