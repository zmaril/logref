---
message: "EVP_DigestInit_ex() failed"
slug: evp-digestinit-ex-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pgcrypto/openssl.c:128"
reproduced: false
---

# `EVP_DigestInit_ex() failed`

## What it means

The `pgcrypto` extension called OpenSSL's `EVP_DigestInit_ex()` to begin a hash computation and the library returned failure. It reports a fault from the cryptographic library, not bad user input.

## When it happens

It fires from `pgcrypto` digest routines when OpenSSL cannot initialize the requested digest — commonly because the algorithm is unavailable in the current OpenSSL build or is blocked by a FIPS policy.

## How to fix

Verify the digest name you passed is supported by the server's OpenSSL library and not disabled by a security policy. Confirm the OpenSSL install is intact. If the algorithm should be available, capture the exact call and report the failure.

## Example

*Illustrative* — the message as logged.

```
ERROR:  EVP_DigestInit_ex() failed
```

## Related

- [EVP_DigestFinal_ex() failed](./evp-digestfinal-ex-failed.md)
- [EVP_DigestUpdate() failed](./evp-digestupdate-failed.md)
