---
message: "connection requires a valid client certificate"
slug: connection-requires-a-valid-client-certificate
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_AUTHORIZATION_SPECIFICATION
    code: "28000"
call_sites:
  - "postgres/src/backend/libpq/auth.c:420"
reproduced: false
---

# `connection requires a valid client certificate`

## What it means

The server's authentication rules require the client to present a valid TLS client certificate for this connection, and none (or an unacceptable one) was provided. The connection is refused.

## When it happens

It happens at connection time when a `pg_hba.conf` entry uses `cert` authentication, or `clientcert=verify-full`/`verify-ca`, and the client did not supply a valid certificate.

## How to fix

Configure the client to present a valid certificate signed by a CA the server trusts, with a subject that matches as required. Provide `sslcert`/`sslkey` on the client, or adjust the `pg_hba.conf` rule if certificate authentication is not intended.

## Example

*Illustrative* — a connection missing a required client certificate.

```text
FATAL:  connection requires a valid client certificate
```

## Related

- [connection to client lost](./connection-to-client-lost.md)
- [could not accept SSL connection](./could-not-accept-ssl-connection-1e04b4.md)
