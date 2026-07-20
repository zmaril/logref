---
message: "could not encode channel binding data"
slug: could-not-encode-channel-binding-data
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1344"
reproduced: false
---

# `could not encode channel binding data`

## What it means

During SCRAM authentication, the server could not base64-encode the TLS channel-binding data. This is an internal step of the SCRAM-over-TLS handshake.

## When it happens

It fires inside the SCRAM exchange when encoding channel-binding data fails. It is not driven by user input and points at an internal or platform-level problem.

## How to fix

This is an internal error, not a credential problem. Check the server log for surrounding messages and verify the build's cryptographic support is intact. Report a reproducible case if it recurs.

## Example

*Illustrative* — channel-binding encoding failing during SCRAM.

```text
ERROR:  could not encode channel binding data
```

## Related

- [could not encode random nonce](./could-not-encode-random-nonce.md)
- [could not encode server signature](./could-not-encode-server-signature.md)
