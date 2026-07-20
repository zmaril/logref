---
message: "could not calculate client signature: %s"
slug: could-not-calculate-client-signature
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1174"
reproduced: false
---

# `could not calculate client signature: %s`

## What it means

During SCRAM authentication, the server failed to compute the client signature. This is an internal cryptographic step; the failure carries the underlying reason and aborts the authentication.

## When it happens

It fires in SCRAM authentication when the HMAC/hash computation for the client signature fails, generally due to an OpenSSL-level problem rather than a wrong password.

## How to fix

This points to a cryptographic-library issue rather than credentials. Check the OpenSSL installation and any FIPS or provider configuration on the server. Review the reason in the message and ensure the crypto backend is functioning.

## Example

*Illustrative* — a failed client-signature calculation.

```text
ERROR:  could not calculate client signature: ...
```

## Related

- [could not calculate server signature](./could-not-calculate-server-signature.md)
- [could not calculate stored key and server key](./could-not-calculate-stored-key-and-server-key.md)
