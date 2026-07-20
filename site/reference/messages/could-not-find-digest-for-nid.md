---
message: "could not find digest for NID %s"
slug: could-not-find-digest-for-nid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:2311"
reproduced: false
---

# `could not find digest for NID %s`

## What it means

The OpenSSL backend could not find a message-digest implementation for a numeric algorithm identifier (NID). The `%s` shows the NID. This is an internal step of certificate or signature handling.

## When it happens

It fires during TLS certificate work when the linked OpenSSL cannot supply a digest for the algorithm in use, usually because that algorithm is not enabled or supported in this OpenSSL build.

## How to fix

Check the OpenSSL version PostgreSQL is linked against and its enabled algorithms. Using a certificate whose digest algorithm the host's OpenSSL supports, or upgrading OpenSSL, resolves it.

## Example

*Illustrative* — a digest algorithm OpenSSL cannot supply.

```text
ERROR:  could not find digest for NID 1234
```

## Related

- [could not convert NID to an ASN1_OBJECT structure](./could-not-convert-nid-to-an-asn1-object-structure.md)
- [could not determine server certificate signature algorithm](./could-not-determine-server-certificate-signature-algorithm.md)
