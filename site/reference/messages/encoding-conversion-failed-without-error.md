---
message: "encoding conversion failed without error"
slug: encoding-conversion-failed-without-error
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:585"
reproduced: false
---

# `encoding conversion failed without error`

## What it means

An internal guard in `COPY`'s encoding-conversion path. A character-set conversion reported neither success nor a specific error, an outcome that should not occur. This is a "can't happen" check.

## When it happens

It fires during `COPY FROM` while converting input from the client encoding to the server encoding, when the conversion routine returns an inconsistent status.

## How to fix

This is not a routine user error. If it reproduces on specific input, capture the input bytes, the client and server encodings, and the server version, and report it to the PostgreSQL developers. Confirm the declared `client_encoding` actually matches the file's encoding.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  encoding conversion failed without error
```

## Related

- [encoding conversion function returned incorrect result for empty input](./encoding-conversion-function-returned-incorrect-result-for-empty-input.md)
- [encoding conversion from to ASCII not supported](./encoding-conversion-from-to-ascii-not-supported.md)
