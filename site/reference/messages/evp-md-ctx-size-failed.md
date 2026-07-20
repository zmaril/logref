---
message: "EVP_MD_CTX_size() failed"
slug: evp-md-ctx-size-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pgcrypto/openssl.c:105"
reproduced: false
---

# `EVP_MD_CTX_size() failed`

## What it means

The `pgcrypto` extension queried the output size of an OpenSSL digest context with `EVP_MD_CTX_size()` and the library returned failure. It reports an OpenSSL-level fault, not bad input.

## When it happens

It fires from `pgcrypto` while preparing a digest or HMAC when OpenSSL cannot report the digest's result length, usually tied to the digest being unavailable or the context being in an unexpected state.

## How to fix

Confirm the digest algorithm is enabled in the server's OpenSSL build and not restricted by FIPS or a system policy. Ensure OpenSSL is healthy. Report the failure with the exact call if a supported algorithm still fails.

## Example

*Illustrative* — the message as logged.

```
ERROR:  EVP_MD_CTX_size() failed
```

## Related

- [EVP_MD_CTX_block_size() failed](./evp-md-ctx-block-size-failed.md)
- [EVP_DigestFinal_ex() failed](./evp-digestfinal-ex-failed.md)
