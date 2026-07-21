---
message: "client sent proto_version=%d but server only supports protocol %d or lower"
slug: client-sent-proto-version-but-server-only-supports-protocol-or-lower
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:496"
reproduced: false
---

# `client sent proto_version=%d but server only supports protocol %d or lower`

## What it means

A client requested a wire protocol version newer than the maximum the server accepts. The server supports the named version or lower, so it cannot speak the requested one.

## When it happens

It occurs at connection time when a client negotiates a protocol version above the server's supported ceiling, usually a newer client against an older server.

## How to fix

Connect with a client that can fall back to the server's protocol version, or upgrade the server so its protocol range includes the client's request. Align the two versions.

## Example

*Illustrative* — a too-new protocol version.

```text
ERROR:  client sent proto_version=4 but server only supports protocol 3 or lower
```

## Related

- [client sent proto version but server only supports protocol or higher](./client-sent-proto-version-but-server-only-supports-protocol-or-higher.md)
- [client requires an unsupported SCRAM extension](./client-requires-an-unsupported-scram-extension.md)
