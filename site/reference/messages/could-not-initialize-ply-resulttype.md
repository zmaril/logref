---
message: "could not initialize PLy_ResultType"
slug: could-not-initialize-ply-resulttype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_resultobject.c:85"
reproduced: false
---

# `could not initialize PLy_ResultType`

## What it means

PL/Python tried to register its internal result type with the Python interpreter during setup and Python reported failure. This type backs the result objects that carry query output back into Python code.

## When it happens

It fires while PL/Python initializes, when the interpreter cannot register the result type — usually a problem in the linked Python library.

## How to fix

This is an internal guard around the Python runtime. Confirm the Python installation PL/Python was built against is present and healthy, and repair or reinstall it if needed. If it recurs on a working interpreter, capture the log and report it.

## Example

*Illustrative* — PL/Python's result type failed to register.

```text
ERROR:  could not initialize PLy_ResultType
```

## Related

- [could not initialize PLy_PlanType](./could-not-initialize-ply-plantype.md)
- [could not initialize PLy_SubtransactionType](./could-not-initialize-ply-subtransactiontype.md)
