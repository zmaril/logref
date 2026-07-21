---
message: "could not create BIO"
slug: could-not-create-bio
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OUT_OF_MEMORY
    code: "53200"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:2348"
reproduced: false
---

# `could not create BIO`

## What it means

The OpenSSL backend could not allocate a BIO object — OpenSSL's basic I/O abstraction — during TLS work. This is an out-of-memory condition inside the cryptographic layer.

## When it happens

It happens during TLS handshake or certificate handling when OpenSSL cannot allocate a BIO, generally under memory pressure.

## How to fix

Free memory on the server host. Persistent failures with ample memory point at an OpenSSL library problem worth investigating on the host.

## Example

*Illustrative* — BIO allocation failing under memory pressure.

```text
ERROR:  could not create BIO
```

## Related

- [could not convert NID to an ASN1_OBJECT structure](./could-not-convert-nid-to-an-asn1-object-structure.md)
- [could not determine server certificate signature algorithm](./could-not-determine-server-certificate-signature-algorithm.md)
