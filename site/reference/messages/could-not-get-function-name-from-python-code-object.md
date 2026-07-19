---
message: "could not get function name from Python code object"
slug: could-not-get-function-name-from-python-code-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_elog.c:264"
reproduced: false
---

# `could not get function name from Python code object`

## What it means

PL/Python was formatting a Python traceback and could not read the function name out of a code object. The function name is part of the location PL/Python shows in error context.

## When it happens

It fires only while PL/Python builds a traceback for a Python exception, when a code object does not expose its function name as expected — an internal mismatch with the running Python interpreter.

## How to fix

This is an internal guard in PL/Python's error handling and does not reflect a problem in your function. If it recurs, note the Python version and report it as a possible incompatibility with that interpreter build.

## Example

*Illustrative* — a code object with no readable function name.

```text
ERROR:  could not get function name from Python code object
```

## Related

- [could not get file name from Python code object](./could-not-get-file-name-from-python-code-object.md)
- [could not get code object from Python frame](./could-not-get-code-object-from-python-frame.md)
