---
message: "binary data has array element type %u (%s) instead of expected %u (%s)"
slug: binary-data-has-array-element-type-instead-of-expected
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:1336"
reproduced: false
---

# `binary data has array element type %u (%s) instead of expected %u (%s)`

## What it means

Binary-format data for an array declared one element type in its header, but the receiving context expected a different element type. The placeholders show the received and expected type OIDs and names. Binary array data is self-describing and must agree with the target type.

## When it happens

It occurs during binary `COPY`, binary protocol parameters, or record decoding when the client sends an array whose element type does not match the column or parameter.

## How to fix

Send the array with the element type the target expects, or switch to text format where type coercion is more forgiving. Client libraries that build binary arrays must use the correct element type OID for the destination.

## Example

*Illustrative* — a binary array with the wrong element type.

```text
ERROR:  binary data has array element type 23 (integer) instead of expected 20 (bigint)
```

## Related

- [binary data has type instead of expected in record column](./binary-data-has-type-instead-of-expected-in-record-column.md)
- [bind message has parameter formats but parameters](./bind-message-has-parameter-formats-but-parameters.md)
