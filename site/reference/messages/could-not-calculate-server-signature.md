---
message: "could not calculate server signature: %s"
slug: could-not-calculate-server-signature
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1432"
reproduced: false
---

# `could not calculate server signature: %s`

## What it means

During SCRAM authentication, the server failed to compute the server signature it returns to the client. This internal cryptographic step failed, with the reason attached, and authentication cannot complete.

## When it happens

It fires in SCRAM authentication when computing the server signature fails at the crypto-library level.

## How to fix

This indicates a cryptographic-library problem, not a bad password. Verify the OpenSSL installation and configuration on the server, check for FIPS/provider issues, and review the underlying reason in the message.

## Example

*Illustrative* — a failed server-signature calculation.

```text
ERROR:  could not calculate server signature: ...
```

## Related

- [could not calculate client signature](./could-not-calculate-client-signature.md)
- [could not calculate stored key and server key](./could-not-calculate-stored-key-and-server-key.md)
