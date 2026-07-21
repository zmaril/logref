---
message: "could not convert SPI error to Python exception"
slug: could-not-convert-spi-error-to-python-exception
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_spi.c:665"
reproduced: false
---

# `could not convert SPI error to Python exception`

## What it means

PL/Python caught an error from a `plpy.execute`/SPI call and could not translate it into a Python exception object. This is an internal step of PL/Python's error handling.

## When it happens

It fires when a database operation run through PL/Python's SPI wrapper fails and building the corresponding Python exception itself fails, for example under memory pressure.

## How to fix

This is an internal error in the PL/Python bridge. Look at the surrounding log for the original SPI error being translated and check for backend memory pressure. Report a reproducible case if it recurs.

## Example

*Illustrative* — an SPI error that cannot be re-raised in Python.

```text
ERROR:  could not convert SPI error to Python exception
```

## Related

- [could not convert error to Python exception](./could-not-convert-error-to-python-exception.md)
- [could not convert Python object into cstring: Python string representation appears to contain null bytes](./could-not-convert-python-object-into-cstring-python-string-representation.md)
