---
message: "unsupported format code: %d"
slug: unsupported-format-code
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/common/printtup.c:291"
  - "postgres/src/backend/commands/explain_dr.c:93"
  - "postgres/src/backend/tcop/fastpath.c:104"
  - "postgres/src/backend/tcop/fastpath.c:451"
  - "postgres/src/backend/tcop/postgres.c:1994"
reproduced: false
---

# `unsupported format code: %d`

## What it means

A client requested a result column format code the server does not support. The placeholder is the code. In the wire protocol, each result column format must be 0 (text) or 1 (binary); any other value is invalid.

## When it happens

A client library sends a malformed Bind message with an out-of-range format code, or a protocol-level bug produces an invalid result-column format specification.

## How to fix

This is a client/driver-level protocol problem. Ensure the client library is well-behaved and up to date; format codes must be only 0 or 1. If you are writing protocol code directly, send valid format codes in the Bind message.

## Example

*Illustrative* — an invalid result format code from the client.

```text
ERROR:  unsupported format code: 2
```

## Related

- [insufficient data left in message](./insufficient-data-left-in-message.md)
- [unexpected EOF on client connection with an open transaction](./unexpected-eof-on-client-connection-with-an-open-transaction.md)
