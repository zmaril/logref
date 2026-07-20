---
message: "could not convert Python object into cstring: Python string representation appears to contain null bytes"
slug: could-not-convert-python-object-into-cstring-python-string-representation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/pl/plpython/plpy_typeio.c:1062"
reproduced: false
---

# `could not convert Python object into cstring: Python string representation appears to contain null bytes`

## What it means

PL/Python tried to convert a returned Python value to text and found embedded null bytes in its string representation. PostgreSQL text values cannot contain null bytes, so the conversion is rejected.

## When it happens

It happens when a PL/Python function returns a value whose string form contains a `\0` byte, for example a `bytes` object with an embedded null being coerced to a text result.

## How to fix

Return a value with no embedded null bytes. Strip or replace `\0` in the Python value before returning it, or return a `bytea` result if the function genuinely needs to carry binary data with nulls.

## Example

*Illustrative* — a returned string containing a null byte.

```text
ERROR:  could not convert Python object into cstring: Python string representation appears to contain null bytes
```

## Related

- [could not convert Python object into cstring: Python string longer than reported length](./could-not-convert-python-object-into-cstring-python-string-longer-than-reported.md)
- [could not convert value to jsonb](./could-not-convert-value-to-jsonb.md)
