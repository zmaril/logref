---
message: "could not duplicate SSL_CTX CA list: %s"
slug: could-not-duplicate-ssl-ctx-ca-list
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:1884"
reproduced: false
---

# `could not duplicate SSL_CTX CA list: %s`

## What it means

The OpenSSL backend could not duplicate the certificate-authority list from the SSL context while setting up a connection. The `%s` gives the reason. This is an internal step of TLS setup.

## When it happens

It fires during TLS handshake setup when copying the configured CA list fails, generally under memory pressure or an OpenSSL-level problem.

## How to fix

Check the server host for memory pressure. If it recurs with ample memory, verify the CA file configured by `ssl_ca_file` is valid and the host's OpenSSL is healthy.

## Example

*Illustrative* — CA list duplication failing during TLS setup.

```text
could not duplicate SSL_CTX CA list: ...reason...
```

## Related

- [could not create BIO](./could-not-create-bio.md)
- [could not find digest for NID](./could-not-find-digest-for-nid.md)
