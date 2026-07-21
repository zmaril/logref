---
message: "could not create SSL context: %s"
slug: could-not-create-ssl-context
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/libpq/be-secure-openssl.c:387"
  - "postgres/src/backend/libpq/be-secure-openssl.c:619"
reproduced: false
---

# `could not create SSL context: %s`

## What it means

The server or a client tool could not create the SSL/TLS context it needs to negotiate encrypted connections; the trailing detail is the TLS library's reason.

## When it happens

It arises when SSL is enabled but the TLS library rejects the context setup — often a bad certificate/key file, an unreadable file, or an unsupported protocol/cipher configuration.

## Is this a problem?

Check the SSL configuration named in the surrounding log: certificate and key paths, file permissions (the key must be readable only by the server user), and the configured protocol versions and cipher lists. Correct the offending setting and reload.

## Example

*Illustrative* — an SSL context that cannot be created.

```text
LOG:  could not create SSL context: unsupported protocol
```

## Related

- [zstd is not supported by this build](./zstd-is-not-supported-by-this-build.md)
- [could not get result of cancel request: %s](./could-not-get-result-of-cancel-request.md)
