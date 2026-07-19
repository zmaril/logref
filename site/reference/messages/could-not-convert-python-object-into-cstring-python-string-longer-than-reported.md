---
message: "could not convert Python object into cstring: Python string longer than reported length"
slug: could-not-convert-python-object-into-cstring-python-string-longer-than-reported
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_typeio.c:1066"
reproduced: false
---

# `could not convert Python object into cstring: Python string longer than reported length`

## What it means

PL/Python tried to read a Python string as a C string and found more bytes than the length Python reported. This is an internal consistency check in PL/Python's type conversion.

## When it happens

It fires while PL/Python converts a returned Python value into text for PostgreSQL, when the string's actual byte length disagrees with the length Python declared.

## How to fix

This is an internal error and usually signals a bug in a custom Python type or C extension that misreports string length. Check any custom `__str__`/`__bytes__` implementations or third-party C modules used by the function.

## Example

*Illustrative* — a string whose length is misreported.

```text
ERROR:  could not convert Python object into cstring: Python string longer than reported length
```

## Related

- [could not convert Python object into cstring: Python string representation appears to contain null bytes](./could-not-convert-python-object-into-cstring-python-string-representation.md)
- [could not convert error to Python exception](./could-not-convert-error-to-python-exception.md)
