---
message: "could not determine server certificate signature algorithm"
slug: could-not-determine-server-certificate-signature-algorithm
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:2294"
reproduced: false
---

# `could not determine server certificate signature algorithm`

## What it means

The TLS backend could not read the signature algorithm from the server's own certificate. This is an internal step of TLS setup; the certificate could not be interpreted as expected.

## When it happens

It fires during TLS initialization when OpenSSL cannot report the server certificate's signature algorithm, usually because the certificate is malformed or uses something the linked OpenSSL does not understand.

## How to fix

Check the server certificate named by `ssl_cert_file` — confirm it is a valid certificate and that the host's OpenSSL supports its signature algorithm. Regenerate the certificate with a supported algorithm if needed.

## Example

*Illustrative* — an unreadable signature algorithm during TLS setup.

```text
ERROR:  could not determine server certificate signature algorithm
```

## Related

- [could not convert NID to an ASN1_OBJECT structure](./could-not-convert-nid-to-an-asn1-object-structure.md)
- [could not create BIO](./could-not-create-bio.md)
