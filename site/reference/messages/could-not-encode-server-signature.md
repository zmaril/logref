---
message: "could not encode server signature"
slug: could-not-encode-server-signature
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1445"
reproduced: false
---

# `could not encode server signature`

## What it means

During SCRAM authentication, the server could not base64-encode the server signature it sends to prove its identity. This is an internal step of the final SCRAM message.

## When it happens

It fires inside the SCRAM exchange when encoding the server signature fails. It is not driven by user input and points at an internal or platform-level problem.

## How to fix

This is an internal error, not a credential problem. Check the server log for surrounding messages and verify the build's cryptographic support is intact. Report a reproducible case if it recurs.

## Example

*Illustrative* — server-signature encoding failing during SCRAM.

```text
ERROR:  could not encode server signature
```

## Related

- [could not encode channel binding data](./could-not-encode-channel-binding-data.md)
- [could not encode random nonce](./could-not-encode-random-nonce.md)
