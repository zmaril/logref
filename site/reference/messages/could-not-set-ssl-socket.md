---
message: "could not set SSL socket: %s"
slug: could-not-set-ssl-socket
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:868"
reproduced: false
---

# `could not set SSL socket: %s`

## What it means

The server could not associate the OpenSSL structure with the client's socket during TLS setup. The trailing text is the library error. Binding the SSL object to the socket is a required step before a TLS handshake.

## When it happens

It fires while the server negotiates TLS on a new connection, when OpenSSL cannot attach its state to the underlying socket. It is logged as a communication error.

## How to fix

This is an internal step in TLS setup and rarely reflects a client mistake. It can accompany OpenSSL problems or a connection that is already broken. Check the server's OpenSSL configuration and version, and the surrounding log. Persistent failures on healthy connections warrant capturing the library error for a report.

## Example

*Illustrative* — binding the SSL object to the socket failed.

```text
LOG:  could not set SSL socket: error:00000000:lib(0):func(0):reason(0)
```

## Related

- [could not update certificate chain](./could-not-update-certificate-chain.md)
- [could not send data to client](./could-not-send-data-to-client.md)
