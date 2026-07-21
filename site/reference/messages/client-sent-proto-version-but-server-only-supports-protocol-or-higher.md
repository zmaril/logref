---
message: "client sent proto_version=%d but server only supports protocol %d or higher"
slug: client-sent-proto-version-but-server-only-supports-protocol-or-higher
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:502"
reproduced: false
---

# `client sent proto_version=%d but server only supports protocol %d or higher`

## What it means

A client requested a wire protocol version older than the minimum the server accepts. The server supports the named version or higher, so it cannot speak the requested one.

## When it happens

It occurs at connection time when a client negotiates a protocol version below the server's supported floor, usually an old client against a newer server.

## How to fix

Upgrade the client library to one that speaks a protocol version the server supports. Align the client and server versions so their protocol ranges overlap.

## Example

*Illustrative* — a too-old protocol version.

```text
ERROR:  client sent proto_version=2 but server only supports protocol 3 or higher
```

## Related

- [client sent proto version but server only supports protocol or lower](./client-sent-proto-version-but-server-only-supports-protocol-or-lower.md)
- [client requires an unsupported SCRAM extension](./client-requires-an-unsupported-scram-extension.md)
