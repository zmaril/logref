---
message: "could not generate a random number"
slug: could-not-generate-a-random-number
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/contrib/pgcrypto/px.c:98"
reproduced: false
---

# `could not generate a random number`

## What it means

The `pgcrypto` extension asked its random-number source for bytes and got a failure. Cryptographic routines need strong randomness for keys, salts, and nonces, and the underlying generator would not produce it.

## When it happens

It fires inside `pgcrypto` functions that need entropy, when the random source (typically the OpenSSL random generator) returns an error — usually a misconfigured or exhausted system entropy source.

## How to fix

Make sure the host has a working entropy source and that the SSL/crypto library it was built against is healthy. On systems where the kernel random device is unavailable in the server's environment, restoring access to it resolves the failure. Retry once the entropy source is working.

## Example

*Illustrative* — pgcrypto cannot obtain randomness.

```text
ERROR:  could not generate a random number
```

## Related

- [could not generate random salt](./could-not-generate-random-salt.md)
- [could not generate random nonce](./could-not-generate-random-nonce.md)
