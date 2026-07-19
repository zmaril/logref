---
message: "could not initialize PLy_SubtransactionType"
slug: could-not-initialize-ply-subtransactiontype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_subxactobject.c:62"
reproduced: false
---

# `could not initialize PLy_SubtransactionType`

## What it means

PL/Python tried to register its internal subtransaction type with the Python interpreter during setup and Python reported failure. This type backs the `plpy.subtransaction` context manager used to roll back part of a function.

## When it happens

It fires while PL/Python initializes, when the interpreter cannot register the subtransaction type — usually a problem in the linked Python library.

## How to fix

This is an internal guard around the Python runtime. Confirm the Python installation PL/Python was built against is present and healthy, and repair or reinstall it if needed. If it recurs on a working interpreter, capture the log and report it.

## Example

*Illustrative* — PL/Python's subtransaction type failed to register.

```text
ERROR:  could not initialize PLy_SubtransactionType
```

## Related

- [could not initialize PLy_ResultType](./could-not-initialize-ply-resulttype.md)
- [could not initialize PLy_CursorType](./could-not-initialize-ply-cursortype.md)
