---
message: "could not convert value \"%s\" to jsonb"
slug: could-not-convert-value-to-jsonb
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/contrib/jsonb_plpython/jsonb_plpython.c:395"
reproduced: false
---

# `could not convert value "%s" to jsonb`

## What it means

The `jsonb_plpython` transform could not turn a Python value into a `jsonb` value. The `%s` shows the offending value. The Python object had no valid JSON representation.

## When it happens

It happens when a PL/Python function using the `jsonb` transform returns or passes a Python object that cannot be encoded as JSON — for example a value that is not a dict, list, string, number, bool, or None.

## How to fix

Return only JSON-serializable Python values from a function using the `jsonb` transform. Convert custom objects to dicts, lists, or scalars before handing them back.

## Example

*Illustrative* — a non-serializable Python value returned as jsonb.

```text
ERROR:  could not convert value "<object>" to jsonb
```

## Related

- [could not convert value of type to jsonpath](./could-not-convert-value-of-type-to-jsonpath.md)
- [could not convert Python object into cstring: Python string representation appears to contain null bytes](./could-not-convert-python-object-into-cstring-python-string-representation.md)
