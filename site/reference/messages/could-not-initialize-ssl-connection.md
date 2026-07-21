---
message: "could not initialize SSL connection: %s"
slug: could-not-initialize-ssl-connection
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:860"
reproduced: false
---

# `could not initialize SSL connection: %s`

## What it means

While setting up an incoming SSL connection, the server's call into OpenSSL to create the connection object failed. The `%s` value gives the library detail. This happens before the TLS handshake can begin, so the connection is dropped.

## When it happens

It is logged at connection level when OpenSSL cannot create the SSL structure for a new connection — usually resource pressure or a problem in the SSL configuration or library.

## How to fix

Check the server log for the OpenSSL detail and confirm SSL is configured with valid certificate and key files and a healthy OpenSSL library. Relieving memory or file-descriptor pressure, and correcting the SSL configuration, lets new SSL connections initialize.

## Example

*Illustrative* — the SSL connection object could not be created.

```text
LOG:  could not initialize SSL connection: out of memory
```

## Related

- [could not initialize SSL connection: SSL context not set up](./could-not-initialize-ssl-connection-ssl-context-not-set-up.md)
- [could not get NID for ASN1_OBJECT object](./could-not-get-nid-for-asn1-object-object.md)
