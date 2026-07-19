---
message: "could not hash stored key: %s"
slug: could-not-hash-stored-key
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1187"
reproduced: false
---

# `could not hash stored key: %s`

## What it means

During SCRAM authentication the server tried to hash the stored key as part of verifying the client's proof and the hashing call failed. This step is part of confirming the client knows the password.

## When it happens

It fires while completing a SCRAM handshake, when the underlying hash operation over the stored key fails — usually a problem in the linked crypto library rather than a wrong password.

## How to fix

This is an internal guard around the crypto library. Make sure the SSL/crypto library the server is built against is healthy and current. If it recurs on a working installation, capture the server log and report a reproducible case; it is not a bad-password condition.

## Example

*Illustrative* — the stored key could not be hashed.

```text
ERROR:  could not hash stored key: SSL error
```

## Related

- [could not get server certificate hash](./could-not-get-server-certificate-hash.md)
- [could not generate random nonce](./could-not-generate-random-nonce.md)
