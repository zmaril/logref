---
message: "could not encode random nonce"
slug: could-not-encode-random-nonce
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1246"
reproduced: false
---

# `could not encode random nonce`

## What it means

During SCRAM authentication, the server could not base64-encode the random nonce it generated for the handshake. This is an internal step of building the server's first SCRAM message.

## When it happens

It fires inside the SCRAM exchange when encoding the nonce fails. It is not driven by user input and points at an internal or platform-level problem.

## How to fix

This is an internal error, not a credential problem. Check the server log for surrounding messages and verify the build's cryptographic support is intact. Report a reproducible case if it recurs.

## Example

*Illustrative* — nonce encoding failing during SCRAM.

```text
ERROR:  could not encode random nonce
```

## Related

- [could not encode channel binding data](./could-not-encode-channel-binding-data.md)
- [could not encode server signature](./could-not-encode-server-signature.md)
