---
message: "could not accept SSL connection: EOF detected"
slug: could-not-accept-ssl-connection-eof-detected
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:964"
  - "postgres/src/backend/libpq/be-secure-openssl.c:1022"
reproduced: false
---

# `could not accept SSL connection: EOF detected`

## What it means

During the TLS handshake for an incoming connection, the client closed the socket before the handshake completed (OpenSSL reported EOF). This is logged as a communication error; no session was established.

## When it happens

A client disconnecting mid-handshake — a health-check or port scanner that opens and closes the socket, a client with an incompatible TLS version or certificate policy giving up, or a network interruption during negotiation.

## How to fix

If it comes from monitoring probes or scanners, it is benign noise and can be ignored or filtered. For real clients, check TLS version and cipher compatibility, certificate trust, and any proxy or load balancer terminating the connection early. Correlate the client address with its own logs to find why it aborted.

## Example

*Illustrative* — a client aborting the TLS handshake.

```text
LOG:  could not accept SSL connection: EOF detected
```

## Related

- [client selected an invalid SASL authentication mechanism](./client-selected-an-invalid-sasl-authentication-mechanism.md)
- [connection to database failed](./connection-to-database-failed-b0df15.md)
