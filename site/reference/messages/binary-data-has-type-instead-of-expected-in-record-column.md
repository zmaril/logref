---
message: "binary data has type %u (%s) instead of expected %u (%s) in record column %d"
slug: binary-data-has-type-instead-of-expected-in-record-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/rowtypes.c:597"
reproduced: false
---

# `binary data has type %u (%s) instead of expected %u (%s) in record column %d`

## What it means

Binary-format data for a record field carried one type but the record's definition expects another at that column. The placeholders show the received and expected type OIDs and names and the column number. Binary record data must match the record type field by field.

## When it happens

It occurs when decoding a binary-format composite or record value whose column types do not line up with the target composite type.

## How to fix

Build the binary record with each field's type matching the target composite type, in order, or use text format. When a client encodes composites in binary, every field's type OID must equal the destination column's type.

## Example

*Illustrative* — a binary record field with the wrong type.

```text
ERROR:  binary data has type 25 (text) instead of expected 23 (integer) in record column 2
```

## Related

- [binary data has array element type instead of expected](./binary-data-has-array-element-type-instead-of-expected.md)
- [attribute of type has wrong type](./attribute-of-type-has-wrong-type.md)
