---
message: "could not compute server key: %s"
slug: could-not-compute-server-key
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:572"
reproduced: false
---

# `could not compute server key: %s`

## What it means

SCRAM authentication could not derive the server key from the stored password verifier. This is an internal step of the SCRAM handshake; the failure means the cryptographic computation itself did not complete.

## When it happens

It fires inside the SCRAM authentication exchange when the server-key derivation fails. In practice this points at a build or platform problem with the cryptographic backend rather than a wrong password.

## How to fix

This is an internal error, not a user credential problem. Check the server log for accompanying messages and verify the PostgreSQL build's cryptographic support is intact. Report a reproducible case to the operators if it recurs.

## Example

*Illustrative* — server-key derivation failing during SCRAM.

```text
ERROR:  could not compute server key: ...reason...
```

## Related

- [could not determine server certificate signature algorithm](./could-not-determine-server-certificate-signature-algorithm.md)
- [could not create BIO](./could-not-create-bio.md)
