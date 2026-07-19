---
message: "attribute %d of type %s has wrong type"
slug: attribute-of-type-has-wrong-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:2429"
reproduced: false
---

# `attribute %d of type %s has wrong type`

## What it means

A composite value held a column whose stored type does not match the type the current row type expects at that position. The placeholders are the attribute number and the type name.

## When it happens

It occurs when a record or composite value is interpreted against a row type that has since changed, or when a function is handed a composite whose column types differ from the declared ones.

## How to fix

Make the value's column types match the expected row type. If a table or type was altered, refresh cached plans and re-fetch the value; if a function received a mismatched record, correct the call so the composite matches the declared type.

## Example

*Illustrative* — a composite column with an unexpected type.

```text
ERROR:  attribute 2 of type record has wrong type
```

## Related

- [attribute of type has been dropped](./attribute-of-type-has-been-dropped.md)
- [binary data has type instead of expected in record column](./binary-data-has-type-instead-of-expected-in-record-column.md)
