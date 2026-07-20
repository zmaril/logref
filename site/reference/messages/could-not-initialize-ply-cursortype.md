---
message: "could not initialize PLy_CursorType"
slug: could-not-initialize-ply-cursortype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_cursorobject.c:73"
reproduced: false
---

# `could not initialize PLy_CursorType`

## What it means

PL/Python tried to register its internal cursor type with the Python interpreter during setup and Python reported failure. The cursor type backs the cursor objects PL/Python functions use to iterate query results.

## When it happens

It fires while PL/Python initializes, when the interpreter cannot register the cursor type — usually a problem in the Python library the server is linked against.

## How to fix

This is an internal guard around the Python runtime. Confirm the Python installation PL/Python was built against is present and healthy. Repairing or reinstalling that Python resolves it; if it recurs on a working interpreter, capture the log and report it.

## Example

*Illustrative* — PL/Python's cursor type failed to register.

```text
ERROR:  could not initialize PLy_CursorType
```

## Related

- [could not initialize PLy_PlanType](./could-not-initialize-ply-plantype.md)
- [could not initialize PLy_ResultType](./could-not-initialize-ply-resulttype.md)
