---
message: "insufficient data left in message"
slug: insufficient-data-left-in-message
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_BINARY_REPRESENTATION
    code: "22P03"
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/pqformat.c:512"
  - "postgres/src/backend/libpq/pqformat.c:530"
  - "postgres/src/backend/libpq/pqformat.c:551"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:872"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:1484"
  - "postgres/src/backend/utils/adt/rowtypes.c:611"
reproduced: false
---

# `insufficient data left in message`

## What it means

A routine reading a binary wire or on-disk message tried to consume more bytes than the message actually contained. It is a length/framing check: the declared or expected size of a field ran past the end of the buffer, so the read is refused rather than allowed to run off the end.

## When it happens

Decoding a binary-format value — a `COPY ... WITH (FORMAT binary)` stream, a binary protocol parameter, or a composite/array `*_recv` function — whose encoded bytes are shorter than the type's layout requires. A truncated dump file, a client that mis-encodes binary values, or a type mismatch between what the client sends and the column expects all produce it.

## How to fix

Treat it as malformed binary input. For `COPY BINARY`, confirm the file was not truncated and that its column list and types match the target table exactly. For binary protocol parameters, check that the client library encodes each value in the format the server's type expects. Switching the problem load to text format isolates whether the issue is the binary encoding.

## Example

*Illustrative* — a binary COPY stream cut short.

```text
ERROR:  insufficient data left in message
```

## Related

- [unsupported format code](./unsupported-format-code.md)
- [could not read COPY data](./could-not-read-copy-data.md)
