---
message: "could not accept SSL connection: %s"
slug: could-not-accept-ssl-connection-1e04b4
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:1005"
reproduced: false
---

# `could not accept SSL connection: %s`

## What it means

The server failed to complete the TLS (SSL) handshake for an incoming connection, with an OpenSSL-reported reason (`%s`). The connection is refused. This variant carries a protocol-violation SQLSTATE.

## When it happens

It happens during connection setup when the TLS handshake fails due to a protocol or certificate problem reported by OpenSSL, such as an unsupported protocol version or a bad message.

## How to fix

Check the client's TLS settings against the server's (`ssl_min_protocol_version`, cipher lists, certificates). Update the client or server TLS configuration so they can negotiate, and verify certificates are valid and trusted.

## Example

*Illustrative* — a failed SSL handshake with an OpenSSL reason.

```text
LOG:  could not accept SSL connection: unsupported protocol
```

## Related

- [could not accept SSL connection](./could-not-accept-ssl-connection-1b0e98.md)
- [connection requires a valid client certificate](./connection-requires-a-valid-client-certificate.md)
