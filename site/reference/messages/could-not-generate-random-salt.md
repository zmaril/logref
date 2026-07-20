---
message: "could not generate random salt"
slug: could-not-generate-random-salt
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:500"
reproduced: false
---

# `could not generate random salt`

## What it means

While creating a SCRAM password verifier, the server tried to generate a random salt and the random source failed. The salt makes each stored password verifier unique even for identical passwords.

## When it happens

It fires during `CREATE ROLE ... PASSWORD` or `ALTER ROLE ... PASSWORD` when the server cannot obtain random bytes for the salt — usually a broken or unavailable system entropy source.

## How to fix

Make sure the host provides working randomness to the server process and that its crypto library is healthy. Once the entropy source is restored, setting passwords works again. Retry the role change after fixing the environment.

## Example

*Illustrative* — the password salt could not be generated.

```text
ERROR:  could not generate random salt
```

## Related

- [could not generate random nonce](./could-not-generate-random-nonce.md)
- [could not generate a random number](./could-not-generate-a-random-number.md)
