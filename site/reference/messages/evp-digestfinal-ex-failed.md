---
message: "EVP_DigestFinal_ex() failed"
slug: evp-digestfinal-ex-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pgcrypto/openssl.c:146"
reproduced: false
---

# `EVP_DigestFinal_ex() failed`

## What it means

The `pgcrypto` extension called OpenSSL's `EVP_DigestFinal_ex()` to finalize a hash and the library returned failure. It is an internal wrapper around the cryptographic library, not a data-validation error.

## When it happens

It fires from `pgcrypto` digest functions (such as `digest()` or `hmac()`) when the OpenSSL digest finalization step fails — for example under an unusual OpenSSL build, a FIPS policy that disables the algorithm, or a library-level fault.

## How to fix

Check the algorithm you requested against what your OpenSSL build allows; a FIPS-restricted build disables some digests. Confirm the server's OpenSSL library is healthy and matches what PostgreSQL was built against. If the algorithm is permitted and the library is sound, capture the call and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  EVP_DigestFinal_ex() failed
```

## Related

- [EVP_DigestInit_ex() failed](./evp-digestinit-ex-failed.md)
- [EVP_DigestUpdate() failed](./evp-digestupdate-failed.md)
