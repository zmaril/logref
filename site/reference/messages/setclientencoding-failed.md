---
message: "SetClientEncoding(%d) failed"
slug: setclientencoding-failed
passthrough: false
api: [elog]
level: [ERROR, LOG]
call_sites:
  - "postgres/src/backend/access/transam/parallel.c:1453"
  - "postgres/src/backend/commands/variable.c:799"
reproduced: false
---

# `SetClientEncoding(%d) failed`

## What it means

An attempt to set the client encoding for a connection failed. The placeholder is the encoding id. The conversion setup between the server encoding and the requested client encoding could not be established.

## When it happens

It arises when `SET client_encoding` (or an internal call during connection setup) requests an encoding for which no valid conversion exists, or when the conversion machinery cannot be initialized. It may be reported as an error to the client or logged.

## How to fix

Use a client encoding that has a defined conversion to and from the server encoding (`\encoding` in psql, or the `client_encoding` GUC). Confirm the encoding name is valid and supported; some pairs have no conversion and cannot be used together.

## Example

*Illustrative* — setting a client encoding with no valid conversion.

```text
ERROR:  SetClientEncoding(42) failed
```

## Related

- [unexpected encoding ID %d for ISO 8859 character sets](./unexpected-encoding-id-for-iso-8859-character-sets.md)
- [requested character too large for encoding: %u](./requested-character-too-large-for-encoding.md)
