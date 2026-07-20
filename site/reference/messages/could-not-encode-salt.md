---
message: "could not encode salt"
slug: could-not-encode-salt
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:717"
  - "postgres/src/backend/libpq/auth-scram.c:726"
reproduced: false
---

# `could not encode salt`

## What it means

SCRAM authentication code could not base64-encode the salt it generated for a password verifier. The encoding step failed, so the SCRAM secret could not be produced.

## When it happens

It should not occur in normal operation. Reaching it points to an internal failure in the encoding routine during SCRAM secret generation, not to anything in your password or configuration.

## How to fix

Treat it as an internal error. Capture the context (a password change or role creation using SCRAM) and report it. If it recurs, check the server's cryptographic backend for faults.

## Example

*Illustrative* — a salt that could not be encoded.

```text
ERROR:  could not encode salt
```

## Related

- [could not encode SCRAM client key](./could-not-encode-scram-client-key.md)
- [could not encode SCRAM server key](./could-not-encode-scram-server-key.md)
