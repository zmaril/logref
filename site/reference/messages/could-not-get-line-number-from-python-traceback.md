---
message: "could not get line number from Python traceback"
slug: could-not-get-line-number-from-python-traceback
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_elog.c:252"
reproduced: false
---

# `could not get line number from Python traceback`

## What it means

PL/Python was formatting a Python traceback and could not read the line number out of a traceback object. The line number is part of the location PL/Python reports in error context.

## When it happens

It fires only while PL/Python builds the traceback for a Python exception, when a traceback object does not expose its line number as expected — an internal mismatch with the running Python interpreter.

## How to fix

This is an internal guard in PL/Python's error handling and does not reflect a fault in your function. If it recurs, note the Python version and report it as a possible incompatibility with that interpreter build.

## Example

*Illustrative* — a traceback with no readable line number.

```text
ERROR:  could not get line number from Python traceback
```

## Related

- [could not get frame from Python traceback](./could-not-get-frame-from-python-traceback.md)
- [could not get code object from Python frame](./could-not-get-code-object-from-python-frame.md)
