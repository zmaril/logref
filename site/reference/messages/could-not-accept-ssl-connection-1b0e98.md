---
message: "could not accept SSL connection: %m"
slug: could-not-accept-ssl-connection-1b0e98
passthrough: false
api: [ereport]
level: [COMMERROR]
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:960"
reproduced: false
---

# `could not accept SSL connection: %m`

## What it means

The server failed while completing the TLS (SSL) handshake for an incoming connection. The `%m` reason is the operating-system or OpenSSL error. The connection is dropped. This is logged as a communication error.

## When it happens

It happens during connection setup when the TLS handshake fails — for example the client aborted, sent malformed TLS, or there is a certificate or protocol problem.

## How to fix

Investigate the client side and TLS configuration: client TLS version and ciphers, certificate validity, and network stability. A single occurrence often just means a client dropped; repeated failures point at a misconfigured client or proxy.

## Example

*Illustrative* — a failed SSL handshake.

```text
LOG:  could not accept SSL connection: Connection reset by peer
```

## Related

- [could not accept SSL connection](./could-not-accept-ssl-connection-1e04b4.md)
- [connection requires a valid client certificate](./connection-requires-a-valid-client-certificate.md)
