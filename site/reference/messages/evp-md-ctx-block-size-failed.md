---
message: "EVP_MD_CTX_block_size() failed"
slug: evp-md-ctx-block-size-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pgcrypto/openssl.c:117"
reproduced: false
---

# `EVP_MD_CTX_block_size() failed`

## What it means

The `pgcrypto` extension queried the block size of an OpenSSL digest context with `EVP_MD_CTX_block_size()` and the library returned failure. It is an internal wrapper around OpenSSL, not a validation of user data.

## When it happens

It fires from `pgcrypto` while setting up a digest or HMAC when OpenSSL cannot report the digest's block size, typically because the digest context is not in the expected state under the server's OpenSSL build.

## How to fix

Check that the requested algorithm is available in the server's OpenSSL library and not blocked by a policy. Verify the OpenSSL install matches the PostgreSQL build. If the algorithm is supported and the failure persists, capture the call and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  EVP_MD_CTX_block_size() failed
```

## Related

- [EVP_MD_CTX_size() failed](./evp-md-ctx-size-failed.md)
- [EVP_DigestInit_ex() failed](./evp-digestinit-ex-failed.md)
