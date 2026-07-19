---
message: "client requires an unsupported SCRAM extension"
slug: client-requires-an-unsupported-scram-extension
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1092"
reproduced: false
---

# `client requires an unsupported SCRAM extension`

## What it means

During SCRAM authentication the client asked for a SCRAM protocol extension the server does not implement. The server cannot honor the requested extension, so authentication cannot proceed.

## When it happens

It occurs at connection time when a client library negotiates a SCRAM extension the server build does not recognize, often due to a version mismatch between client and server.

## How to fix

Use a client and server whose SCRAM support matches, typically by aligning versions. If a client library enables an optional SCRAM extension, disable it or upgrade the server to one that supports it.

## Example

*Illustrative* — an unsupported SCRAM extension.

```text
ERROR:  client requires an unsupported SCRAM extension
```

## Related

- [channel binding not supported by this build](./channel-binding-not-supported-by-this-build.md)
- [client sent proto version but server only supports protocol or higher](./client-sent-proto-version-but-server-only-supports-protocol-or-higher.md)
