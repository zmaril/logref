---
message: "SPI_cursor_open() failed: %s"
slug: spi-cursor-open-failed-14613b
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_cursorobject.c:143"
  - "postgres/src/pl/plpython/plpy_cursorobject.c:285"
reproduced: false
---

# `SPI_cursor_open() failed: %s`

## What it means

Internal error surfaced through SPI. Opening a cursor over a plan via the Server Programming Interface failed. The placeholder carries the underlying reason. SPI is the interface PL languages and some C code use to run SQL.

## When it happens

It fires from a PL function or C extension that opens an SPI cursor when the underlying query cannot be set up as a cursor — often carrying a more specific error in the detail (a real query problem in the code that called SPI).

## How to fix

Read the attached reason: it names the real cause. Usually the fix is in the calling PL/extension code — correct the query it tries to open as a cursor. If the reason points at data or a schema issue, address that.

## Example

*Illustrative* — an SPI cursor open reporting a failure.

```text
ERROR:  SPI_cursor_open() failed: syntax error
```

## Related

- [SPI_prepare failed: %s](./spi-prepare-failed-b6db8e.md)
- [SPI_execute_extended failed executing query "%s": %s](./spi-execute-extended-failed-executing-query.md)
