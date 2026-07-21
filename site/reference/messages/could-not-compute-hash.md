---
message: "could not compute %s hash: %s"
slug: could-not-compute-hash
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/utils/adt/cryptohashfuncs.c:46"
  - "postgres/src/backend/utils/adt/cryptohashfuncs.c:68"
reproduced: false
---

# `could not compute %s hash: %s`

## What it means

Internal error. A cryptographic-hash SQL function (such as `sha256()` or `md5()` over a large input) failed inside the underlying hash library. The placeholders are the hash type and the library error. The hash computation did not complete.

## When it happens

It should not occur in normal operation. Reaching it points to a failure in the cryptographic backend — for example an OpenSSL error or a resource shortage — rather than to invalid SQL.

## How to fix

Check the library error in the message. Verify the server's cryptographic backend (OpenSSL) is healthy and that the system is not out of memory. If it recurs, capture the input size and the library detail and report it.

## Example

*Illustrative* — a hash library failure.

```text
ERROR:  could not compute sha256 hash: no more memory
```

## Related

- [could not create OpenSSL BIO structure](./could-not-create-openssl-bio-structure.md)
- [could not encode salt](./could-not-encode-salt.md)
