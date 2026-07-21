---
message: "could not free OpenSSL BIO structure"
slug: could-not-free-openssl-bio-structure
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/sslinfo/sslinfo.c:178"
  - "postgres/contrib/sslinfo/sslinfo.c:469"
  - "postgres/src/backend/libpq/be-secure-openssl.c:2385"
reproduced: false
---

# `could not free OpenSSL BIO structure`

## What it means

Internal error. SSL-related code (here `sslinfo`) got a failure while freeing an OpenSSL BIO object. The placeholder-free message reflects an unexpected return from the OpenSSL library during cleanup of an I/O abstraction structure.

## When it happens

It does not arise from ordinary SQL. It points to an unusual OpenSSL library state or a mismatch between the library the server was built against and the one loaded, rather than to user input.

## How to fix

Treat it as an internal/library issue. Confirm the OpenSSL version the server links against is consistent and correctly installed. Capture the operation (the `sslinfo` function involved) and report it with the OpenSSL version. It does not indicate a data problem.

## Example

*Illustrative* — an OpenSSL cleanup failure.

```text
ERROR:  could not free OpenSSL BIO structure
```

## Related

- [could not finalize context](./could-not-finalize-context.md)
- [could not initialize context](./could-not-initialize-context.md)
