---
message: "SSL error: %s"
slug: ssl-error
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:1231"
  - "postgres/src/backend/libpq/be-secure-openssl.c:1296"
reproduced: false
---

# `SSL error: %s`

## What it means

An error occurred in the SSL/TLS layer of a connection. The placeholder carries the message from the SSL library. The encrypted channel could not be established or maintained.

## When it happens

It arises during TLS handshake or data transfer — certificate problems, protocol/cipher mismatches, an untrusted or expired certificate, or an unexpected disconnect. It is reported at the communication layer, so it often accompanies a dropped connection.

## How to fix

Read the SSL library detail: it usually names the specific cause (bad certificate, unknown CA, protocol version, and so on). Fix the certificate chain, trust store, `sslmode`, or `ssl`/cipher settings on whichever side the detail implicates. Confirm client and server agree on a supported TLS version.

## Example

*Illustrative* — a TLS-layer failure on a connection.

```text
LOG:  SSL error: certificate verify failed
```

## Related

- [terminating connection because protocol synchronization was lost](./terminating-connection-because-protocol-synchronization-was-lost.md)
- [server tried to send oversize GSSAPI packet (%zu > %zu)](./server-tried-to-send-oversize-gssapi-packet.md)
