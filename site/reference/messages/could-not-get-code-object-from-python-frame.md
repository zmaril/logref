---
message: "could not get code object from Python frame"
slug: could-not-get-code-object-from-python-frame
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_elog.c:260"
reproduced: false
---

# `could not get code object from Python frame`

## What it means

PL/Python was building a traceback for a Python error and could not read the code object out of a stack frame. The code object holds the file name and line information PL/Python reports in error context.

## When it happens

It fires only while PL/Python formats a Python exception's traceback, when a frame does not expose its code object as expected — an internal mismatch with the running Python interpreter.

## How to fix

This is an internal guard in PL/Python's error handling. It does not reflect a fault in your function's logic. If it recurs, note the Python version in use and report it, since it points at an incompatibility between PL/Python and that interpreter build.

## Example

*Illustrative* — a frame with no readable code object.

```text
ERROR:  could not get code object from Python frame
```

## Related

- [could not get frame from Python traceback](./could-not-get-frame-from-python-traceback.md)
- [could not get line number from Python traceback](./could-not-get-line-number-from-python-traceback.md)
