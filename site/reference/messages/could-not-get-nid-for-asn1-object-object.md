---
message: "could not get NID for ASN1_OBJECT object"
slug: could-not-get-nid-for-asn1-object-object
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:2358"
reproduced: false
---

# `could not get NID for ASN1_OBJECT object`

## What it means

During SSL setup the server asked OpenSSL for the numeric identifier (NID) of an ASN.1 object and OpenSSL did not recognize it. NIDs name algorithms and extensions; the server needs one to work with a certificate field.

## When it happens

It fires while processing an SSL certificate, when an ASN.1 object in it maps to no known NID in the linked OpenSSL — usually a certificate using an algorithm or object the library does not know.

## How to fix

Use a server certificate whose algorithms and extensions the linked OpenSSL version supports, and make sure the OpenSSL build is current. Replacing a certificate that uses an unsupported object identifier resolves it.

## Example

*Illustrative* — an unrecognized ASN.1 object in a certificate.

```text
ERROR:  could not get NID for ASN1_OBJECT object
```

## Related

- [could not generate server certificate hash](./could-not-generate-server-certificate-hash.md)
- [could not initialize ssl connection](./could-not-initialize-ssl-connection.md)
