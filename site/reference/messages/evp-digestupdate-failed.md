---
message: "EVP_DigestUpdate() failed"
slug: evp-digestupdate-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pgcrypto/openssl.c:137"
reproduced: false
---

# `EVP_DigestUpdate() failed`

## What it means

The `pgcrypto` extension called OpenSSL's `EVP_DigestUpdate()` to feed data into a running hash and the library returned failure. It reflects an OpenSSL-level fault rather than invalid input.

## When it happens

It fires from `pgcrypto` digest functions while streaming bytes into the digest, when the underlying OpenSSL call fails. This is rare and points at the cryptographic library or its configuration.

## How to fix

Confirm the server's OpenSSL library is healthy and that the chosen algorithm is enabled. If a FIPS or system policy restricts the digest, switch to a permitted algorithm. Persistent failures with a supported algorithm are worth reporting with the exact call.

## Example

*Illustrative* — the message as logged.

```
ERROR:  EVP_DigestUpdate() failed
```

## Related

- [EVP_DigestInit_ex() failed](./evp-digestinit-ex-failed.md)
- [EVP_MD_CTX_size() failed](./evp-md-ctx-size-failed.md)
