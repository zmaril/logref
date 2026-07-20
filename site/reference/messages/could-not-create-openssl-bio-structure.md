---
message: "could not create OpenSSL BIO structure"
slug: could-not-create-openssl-bio-structure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OUT_OF_MEMORY
    code: "53200"
call_sites:
  - "postgres/contrib/sslinfo/sslinfo.c:162"
  - "postgres/contrib/sslinfo/sslinfo.c:432"
reproduced: false
---

# `could not create OpenSSL BIO structure`

## What it means

An `sslinfo` function could not allocate an OpenSSL BIO (basic I/O) object. The condition reflects an out-of-memory or OpenSSL initialization failure while inspecting the connection's TLS state.

## When it happens

Calling an `sslinfo` function on a TLS connection when the server is out of memory or OpenSSL fails to create the object.

## How to fix

Check server memory and OpenSSL health. Free memory if the host is under pressure, and ensure the OpenSSL library is functioning. Retry the `sslinfo` call once resources are available; a persistent failure warrants inspecting the OpenSSL build.

## Example

*Illustrative* — a failed OpenSSL allocation.

```text
ERROR:  could not create OpenSSL BIO structure
```

## Related

- [could not compute hash](./could-not-compute-hash.md)
- [could not accept SSL connection: EOF detected](./could-not-accept-ssl-connection-eof-detected.md)
