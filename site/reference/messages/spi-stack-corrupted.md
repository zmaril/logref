---
message: "SPI stack corrupted"
slug: spi-stack-corrupted
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/spi.c:109"
  - "postgres/src/backend/executor/spi.c:119"
reproduced: false
---

# `SPI stack corrupted`

## What it means

Internal error. The SPI call stack, which tracks nested SPI contexts as PL functions call into one another, was found in an inconsistent state. It signals mismatched `SPI_connect`/`SPI_finish` calls or memory corruption.

## When it happens

It fires when SPI bookkeeping detects an unbalanced or damaged stack — typically a C extension or PL implementation that connects and finishes SPI contexts incorrectly, or a longjmp that skipped cleanup.

## How to fix

This is an internal invariant guard. If a specific extension or PL is involved, its SPI usage is likely unbalanced; report it to that code's maintainers. Capture the call path that triggers it.

## Example

*Illustrative* — a corrupted SPI stack.

```text
ERROR:  SPI stack corrupted
```

## Related

- [SPI_cursor_open() failed: %s](./spi-cursor-open-failed-14613b.md)
- [resjunk output columns are not implemented](./resjunk-output-columns-are-not-implemented.md)
