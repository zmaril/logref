---
message: "array is not a valid oidvector"
slug: array-is-not-a-valid-oidvector
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/oid.c:129"
reproduced: false
---

# `array is not a valid oidvector`

## What it means

A value was interpreted as an `oidvector` (the internal fixed OID vector used in catalogs) but did not have the shape a valid `oidvector` requires.

## When it happens

It occurs when converting or inputting an array into `oidvector` and the array is multidimensional, contains nulls, or is otherwise malformed for the type.

## How to fix

Provide a one-dimensional array of OIDs with no nulls. `oidvector` is mainly an internal catalog type; if you are not deliberately building catalog values, use a regular `oid[]` instead.

## Example

*Illustrative* — a malformed oidvector value.

```text
ERROR:  array is not a valid oidvector
```

## Related

- [array is not a valid int2vector](./array-is-not-a-valid-int2vector.md)
- [arrays must have same bounds](./arrays-must-have-same-bounds.md)
