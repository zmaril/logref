---
message: "could not convert error to Python exception"
slug: could-not-convert-error-to-python-exception
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_elog.c:575"
reproduced: false
---

# `could not convert error to Python exception`

## What it means

PL/Python caught a PostgreSQL error and tried to turn it into a Python exception object, and that translation failed. This is an internal step of PL/Python's error handling.

## When it happens

It fires inside PL/Python while re-raising a database error as a Python exception, when constructing the exception object itself fails — for example under Python-side memory pressure.

## How to fix

This is an internal error in the PL/Python bridge. Check for memory pressure in the backend and look at the surrounding log for the original database error being translated. Report a reproducible case if it recurs.

## Example

*Illustrative* — PL/Python failing to build the exception.

```text
ERROR:  could not convert error to Python exception
```

## Related

- [could not convert SPI error to Python exception](./could-not-convert-spi-error-to-python-exception.md)
- [could not convert Python object into cstring: Python string longer than reported length](./could-not-convert-python-object-into-cstring-python-string-longer-than-reported.md)
