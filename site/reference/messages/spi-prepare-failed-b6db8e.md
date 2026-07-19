---
message: "SPI_prepare failed: %s"
slug: spi-prepare-failed-b6db8e
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_cursorobject.c:135"
  - "postgres/src/pl/plpython/plpy_spi.c:129"
reproduced: false
---

# `SPI_prepare failed: %s`

## What it means

Internal error surfaced through SPI. Preparing (parsing and planning) a query through `SPI_prepare` failed. The placeholder carries the underlying reason, which is usually an ordinary parse/plan error in the query the caller supplied.

## When it happens

It fires from PL/extension code that prepares an SPI plan when that query cannot be parsed or planned — the detail names the real error.

## How to fix

Read the attached reason: it identifies the parse/plan problem. The fix belongs in the code that built the query string for `SPI_prepare` — correct the SQL it tried to prepare.

## Example

*Illustrative* — SPI_prepare reporting a parse error.

```text
ERROR:  SPI_prepare failed: syntax error at or near "FROM"
```

## Related

- [SPI_prepare failed for "%s"](./spi-prepare-failed-for.md)
- [SPI_cursor_open() failed: %s](./spi-cursor-open-failed-14613b.md)
