---
message: "could not initialize SSL connection: SSL context not set up"
slug: could-not-initialize-ssl-connection-ssl-context-not-set-up
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:846"
reproduced: false
---

# `could not initialize SSL connection: SSL context not set up`

## What it means

A client tried to start an SSL connection, but the server has no SSL context ready. The context holds the loaded certificate, key, and TLS settings, and without it the server cannot begin a TLS handshake.

## When it happens

It is logged at connection level when SSL was requested but the server's SSL context was never established — usually SSL is not fully enabled, or the certificate/key failed to load at startup.

## How to fix

Make sure `ssl = on` and that the server certificate and key files exist, are readable by the server, and loaded without error at startup (check the startup log). Fix the SSL configuration and reload; only then can the server accept SSL connections.

## Example

*Illustrative* — an SSL request with no server SSL context.

```text
LOG:  could not initialize SSL connection: SSL context not set up
```

## Related

- [could not initialize SSL connection](./could-not-initialize-ssl-connection.md)
- [could not get server certificate hash](./could-not-get-server-certificate-hash.md)
