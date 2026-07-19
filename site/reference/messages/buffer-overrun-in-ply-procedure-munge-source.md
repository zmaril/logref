---
message: "buffer overrun in PLy_procedure_munge_source"
slug: buffer-overrun-in-ply-procedure-munge-source
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/pl/plpython/plpy_procedure.c:464"
reproduced: false
---

# `buffer overrun in PLy_procedure_munge_source`

## What it means

PL/Python's routine that rewrites a function's source into an executable wrapper computed a buffer size that did not hold the result. This is an internal consistency failure in the language handler, not a fault in the Python code itself.

## When it happens

It is a can't-happen guard in the `plpython` source-munging step. It would only appear from a bug in the language handler.

## How to fix

There is no user-facing fix in the function's Python body. If it appears, capture the function definition that triggered it and the server and Python versions, and report it as a possible bug.

## Example

*Illustrative* — the internal size guard.

```text
FATAL:  buffer overrun in PLy_procedure_munge_source
```

## Related

- [cannot allocate a pmchild slot for backend type](./cannot-allocate-a-pmchild-slot-for-backend-type.md)
- [cannot add more timeout reasons](./cannot-add-more-timeout-reasons.md)
