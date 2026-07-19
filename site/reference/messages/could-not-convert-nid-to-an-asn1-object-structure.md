---
message: "could not convert NID %d to an ASN1_OBJECT structure"
slug: could-not-convert-nid-to-an-asn1-object-structure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:2366"
reproduced: false
---

# `could not convert NID %d to an ASN1_OBJECT structure`

## What it means

The OpenSSL backend could not turn a numeric identifier (NID) for a cryptographic algorithm or curve into the ASN.1 object structure it needs. The `%d` is the NID. This points at an OpenSSL-level problem building the object.

## When it happens

It happens during TLS setup or certificate handling when converting an algorithm identifier fails, usually because the OpenSSL library on the host does not recognize or support that identifier.

## How to fix

Check that the OpenSSL version PostgreSQL is linked against supports the algorithm or curve in use. Upgrading or reconfiguring OpenSSL, or choosing a supported cipher or curve in the server's TLS settings, resolves it.

## Example

*Illustrative* — an unrecognized NID during TLS setup.

```text
ERROR:  could not convert NID 12345 to an ASN1_OBJECT structure
```

## Related

- [could not create BIO](./could-not-create-bio.md)
- [could not determine server certificate signature algorithm](./could-not-determine-server-certificate-signature-algorithm.md)
