---
message: "channel binding not supported by this build"
slug: channel-binding-not-supported-by-this-build
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1357"
reproduced: false
---

# `channel binding not supported by this build`

## What it means

SCRAM channel binding was requested, but the server or client build has no SSL support, so channel binding cannot be performed. Channel binding ties authentication to the TLS channel, which requires a build with SSL.

## When it happens

It occurs during SCRAM authentication when channel binding is required but the binary was built without OpenSSL, or the connection is not using SSL.

## How to fix

Use a build compiled with SSL support and connect over an SSL connection, or relax the channel-binding requirement if your security policy allows. Confirm SSL is enabled on both ends.

## Example

*Illustrative* — channel binding on a non-SSL build.

```text
ERROR:  channel binding not supported by this build
```

## Related

- [client requires an unsupported SCRAM extension](./client-requires-an-unsupported-scram-extension.md)
- [client certificates can only be checked if a root certificate store is available](./client-certificates-can-only-be-checked-if-a-root-certificate-store-is-available.md)
