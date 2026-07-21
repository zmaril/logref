---
message: "unrecognized SSL error code: %d"
slug: unrecognized-ssl-error-code
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:1027"
  - "postgres/src/backend/libpq/be-secure-openssl.c:1242"
  - "postgres/src/backend/libpq/be-secure-openssl.c:1312"
reproduced: false
---

# `unrecognized SSL error code: %d`

## What it means

Internal error in the TLS layer. After an SSL library call failed, Postgres asked the library to classify the error and received a code it does not have specific handling for. The message reports the numeric code. It is raised at the connection layer.

## When it happens

An underlying SSL library call returned an error whose classification code the server does not map to a known case — typically an unusual TLS failure during a connection handshake or data transfer.

## How to fix

Investigate the TLS connection itself: check the SSL library version, certificate and key configuration, and client-side TLS settings, since the specific error came from the library. The numeric code and surrounding log context help pinpoint the underlying TLS fault. Capture it and report it if the configuration is sound.

## Example

*Illustrative* — an unclassified SSL error.

```text
LOG:  unrecognized SSL error code: 9
```

## Related

- [could not accept ssl connection](./could-not-accept-ssl-connection-1b0e98.md)
- [unrecognized ssl error code](./unrecognized-ssl-error-code.md)
