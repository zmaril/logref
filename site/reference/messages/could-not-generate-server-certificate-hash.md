---
message: "could not generate server certificate hash"
slug: could-not-generate-server-certificate-hash
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:2318"
reproduced: false
---

# `could not generate server certificate hash`

## What it means

During SSL setup the server tried to compute a hash of its own certificate and the hashing call failed. That hash is used for channel binding, which ties an authenticated session to the exact TLS connection.

## When it happens

It fires while establishing an SSL connection with channel binding, when the OpenSSL digest of the server certificate cannot be computed — usually a certificate the library cannot process with the expected algorithm.

## How to fix

This is an internal guard around the SSL library. Confirm the server certificate is valid and uses an algorithm the linked OpenSSL supports, and that the OpenSSL build is healthy. Replacing a problematic certificate usually resolves it; capture the log if it recurs on a known-good certificate.

## Example

*Illustrative* — the certificate hash could not be computed.

```text
ERROR:  could not generate server certificate hash
```

## Related

- [could not get server certificate hash](./could-not-get-server-certificate-hash.md)
- [could not get NID for ASN1_OBJECT object](./could-not-get-nid-for-asn1-object-object.md)
