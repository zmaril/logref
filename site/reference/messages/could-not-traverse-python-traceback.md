---
message: "could not traverse Python traceback"
slug: could-not-traverse-python-traceback
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_elog.c:338"
reproduced: false
---

# `could not traverse Python traceback`

## What it means

PL/Python could not walk the traceback of a Python exception while building the error it reports back to the server. The traceback carries the call chain of the failing Python code, and traversing it failed.

## When it happens

It fires inside PL/Python's error handling, when an exception has occurred in a Python function and the extension cannot read the traceback object to attach line information.

## How to fix

This is an internal failure in PL/Python's error reporting rather than a problem with your SQL. The original Python error is what matters; look for it alongside this message. If the traceback traversal fails consistently, it may indicate a mismatch between the server and the Python runtime it links against — verify the PL/Python installation.

## Example

*Illustrative* — the traceback could not be walked.

```text
ERROR:  could not traverse Python traceback
```

## Related

- [could not set up XML error handler](./could-not-set-up-xml-error-handler.md)
- [could not translate strategy number for index AM](./could-not-translate-strategy-number-for-index-am.md)
