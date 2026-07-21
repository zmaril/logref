---
message: "could not update certificate chain: %s"
slug: could-not-update-certificate-chain
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:1853"
reproduced: false
---

# `could not update certificate chain: %s`

## What it means

The server could not update its TLS certificate chain from the configured files. The trailing text is the OpenSSL error. The server flags this as an internal error. This happens when the SSL configuration is reloaded.

## When it happens

It fires during a configuration reload that reapplies TLS settings, when OpenSSL cannot rebuild the certificate chain from `ssl_cert_file` and related files — a malformed or mismatched certificate.

## How to fix

Check the certificate and key files named by `ssl_cert_file`, `ssl_key_file`, and `ssl_ca_file`. Make sure the certificate chain is complete and valid and that the files parse. Correct the offending file and reload again. The existing connections keep the previous, working configuration until a valid reload succeeds.

## Example

*Illustrative* — the certificate chain failed to reload.

```text
LOG:  could not update certificate chain: error:0909006C:PEM routines:get_name:no start line
```

## Related

- [could not set SSL socket](./could-not-set-ssl-socket.md)
- [could not send data to client](./could-not-send-data-to-client.md)
