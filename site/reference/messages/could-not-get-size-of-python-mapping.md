---
message: "could not get size of Python mapping"
slug: could-not-get-size-of-python-mapping
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/contrib/hstore_plpython/hstore_plpython.c:147"
reproduced: false
---

# `could not get size of Python mapping`

## What it means

The `hstore_plpython` transform tried to read how many entries a Python mapping holds while converting it to `hstore` and could not. It needs the size to allocate the resulting `hstore`.

## When it happens

It happens when a PL/Python function returns an `hstore`-typed value from a mapping whose size cannot be read — for example an object that looks like a dict but does not report a length.

## How to fix

Return a real Python dictionary for an `hstore` result. If you are using a custom mapping type, convert it to a plain `dict` first. Confirm the function's declared return type matches the `hstore_plpython` transform.

## Example

*Illustrative* — a mapping whose size could not be read.

```text
ERROR:  could not get size of Python mapping
```

## Related

- [could not get items from Python mapping](./could-not-get-items-from-python-mapping.md)
- [could not get code object from Python frame](./could-not-get-code-object-from-python-frame.md)
