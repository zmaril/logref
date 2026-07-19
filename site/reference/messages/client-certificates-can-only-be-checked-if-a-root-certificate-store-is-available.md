---
message: "client certificates can only be checked if a root certificate store is available"
slug: client-certificates-can-only-be-checked-if-a-root-certificate-store-is-available
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/libpq/auth.c:409"
reproduced: false
---

# `client certificates can only be checked if a root certificate store is available`

## What it means

Client-certificate authentication was configured, but the server has no root certificate store to validate client certificates against. Without a trusted root, the server cannot verify a client certificate, so it refuses to start the check.

## When it happens

It occurs when `pg_hba.conf` uses `clientcert` or the `cert` auth method but `ssl_ca_file` is not set to a valid root certificate file.

## How to fix

Set `ssl_ca_file` to a certificate authority file that can validate client certificates, then reload the server. Provide the root store before requiring client certificates.

## Example

*Illustrative* — client certificates without a root store.

```text
FATAL:  client certificates can only be checked if a root certificate store is available
```

## Related

- [channel binding not supported by this build](./channel-binding-not-supported-by-this-build.md)
- [client requires an unsupported SCRAM extension](./client-requires-an-unsupported-scram-extension.md)
