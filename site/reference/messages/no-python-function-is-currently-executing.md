---
message: "no Python function is currently executing"
slug: no-python-function-is-currently-executing
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_main.c:386"
  - "postgres/src/pl/plpython/plpy_main.c:428"
reproduced: false
---

# `no Python function is currently executing`

## What it means

A PL/Python helper that only makes sense inside a running PL/Python function was called when no PL/Python function was active. There is no execution context for it to act on.

## When it happens

It arises from PL/Python introspection or context helpers invoked outside a PL/Python function body — for example indirectly through a path that reaches PL/Python support code with no active call.

## How to fix

Only use PL/Python context helpers from within an executing PL/Python function. Review the call path to ensure the helper runs inside a `plpython3u` function rather than from some outer context.

## Example

*Illustrative* — a PL/Python context call with nothing executing.

```text
ERROR:  no Python function is currently executing
```

## Related

- [no value found for parameter](./no-value-found-for-parameter.md)
- [invalid portal in SPI cursor operation](./invalid-portal-in-spi-cursor-operation.md)
