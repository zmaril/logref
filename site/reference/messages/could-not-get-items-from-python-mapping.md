---
message: "could not get items from Python mapping"
slug: could-not-get-items-from-python-mapping
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/contrib/hstore_plpython/hstore_plpython.c:153"
reproduced: false
---

# `could not get items from Python mapping`

## What it means

The `hstore_plpython` transform tried to read the key/value pairs out of a Python dictionary to build an `hstore` value and could not. It iterates the mapping's items to convert each pair.

## When it happens

It happens when a PL/Python function returns a value declared as `hstore` that is a mapping the transform cannot enumerate — for example an object that looks like a dict but does not support item iteration.

## How to fix

Return a real Python dictionary whose keys and values convert to text for an `hstore` result. If you are returning a custom mapping type, convert it to a plain `dict` first. Confirm the function's return type and the transform (`hstore_plpython`) match.

## Example

*Illustrative* — an object that is not a proper mapping.

```text
ERROR:  could not get items from Python mapping
```

## Related

- [could not get size of Python mapping](./could-not-get-size-of-python-mapping.md)
- [could not get code object from Python frame](./could-not-get-code-object-from-python-frame.md)
