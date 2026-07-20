---
message: "could not calculate stored key and server key: %s"
slug: could-not-calculate-stored-key-and-server-key
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/common/scram-common.c:244"
reproduced: false
---

# `could not calculate stored key and server key: %s`

## What it means

SCRAM common code failed while deriving the stored key and server key from a password. This internal cryptographic step failed, with the reason attached, so the SCRAM secret could not be produced.

## When it happens

It fires when building or verifying a SCRAM secret (for example while setting a password or authenticating) and the key-derivation computation fails at the crypto level.

## How to fix

This is a cryptographic-library failure rather than a user error. Check the OpenSSL/crypto installation and configuration on the affected client or server, including any FIPS mode, and review the underlying reason.

## Example

*Illustrative* — a failed SCRAM key derivation.

```text
ERROR:  could not calculate stored key and server key: ...
```

## Related

- [could not calculate client signature](./could-not-calculate-client-signature.md)
- [could not calculate server signature](./could-not-calculate-server-signature.md)
