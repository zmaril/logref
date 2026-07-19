---
message: "invalid length in external bit string"
slug: invalid-length-in-external-bit-string
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_BINARY_REPRESENTATION
    code: "22P03"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:345"
  - "postgres/src/backend/utils/adt/varbit.c:650"
reproduced: false
---

# `invalid length in external bit string`

## What it means

A `bit`/`bit varying` value in binary (external) form declared a bit length that does not agree with the byte count that follows. The binary representation is inconsistent, so it is rejected.

## When it happens

It arises when receiving a bit-string value in binary protocol format or via binary `COPY` where the length header and payload disagree — usually a client encoding bug, a mismatched type, or corrupted binary input.

## How to fix

If a client sends bit values in binary format, make sure it encodes the leading bit-length correctly and pads the final byte as the format requires. Using the text format avoids this class of encoding error. For binary `COPY`, confirm the column types match the data exactly.

## Example

*Illustrative* — a bit-string binary value with a mismatched length.

```text
ERROR:  invalid length in external bit string
```

## Related

- [invalid compression method](./invalid-compression-method-b1b2db.md)
- [new bit must be 0 or 1](./new-bit-must-be-0-or-1.md)
