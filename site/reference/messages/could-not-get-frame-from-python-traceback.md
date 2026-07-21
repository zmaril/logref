---
message: "could not get frame from Python traceback"
slug: could-not-get-frame-from-python-traceback
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_elog.c:256"
reproduced: false
---

# `could not get frame from Python traceback`

## What it means

PL/Python was building a traceback for a Python error and could not read a stack frame out of the traceback object. Frames carry the file, function, and line PL/Python reports.

## When it happens

It fires only while PL/Python formats a Python exception, when a traceback object does not expose its frame as expected — an internal mismatch with the running Python interpreter.

## How to fix

This is an internal guard in PL/Python's error handling and does not reflect a fault in your function's logic. If it recurs, note the Python version in use and report it as a possible incompatibility with that interpreter build.

## Example

*Illustrative* — a traceback with no readable frame.

```text
ERROR:  could not get frame from Python traceback
```

## Related

- [could not get code object from Python frame](./could-not-get-code-object-from-python-frame.md)
- [could not get line number from Python traceback](./could-not-get-line-number-from-python-traceback.md)
