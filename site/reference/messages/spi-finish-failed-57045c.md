---
message: "SPI_finish() failed"
slug: spi-finish-failed-57045c
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpython/plpy_exec.c:532"
  - "postgres/src/pl/tcl/pltcl.c:961"
  - "postgres/src/pl/tcl/pltcl.c:1284"
  - "postgres/src/pl/tcl/pltcl.c:1362"
reproduced: false
---

# `SPI_finish() failed`

## What it means

Internal error. Server code closing down an SPI session called `SPI_finish()` and it returned a failure. The placeholder-free message means SPI's own bookkeeping detected an inconsistency at teardown — for example being called when no SPI session is active. Callers treat it as a `can't happen` guard.

## When it happens

It arises from SPI-using code (here PL/Python) at the end of an SPI operation. It reflects an internal state problem in the calling module rather than anything in the SQL that was run.

## How to fix

Treat it as a bug in the calling code or extension. If it appears only with a particular procedural-language function or extension, suspect that module and confirm it was built for this server version. Capture the steps and report it.

## Example

*Illustrative* — emitted internally at SPI teardown.

```text
ERROR:  SPI_finish() failed
```

## Related

- [SPI_cursor_open failed](./spi-cursor-open-failed-29c557.md)
- [SPI_prepare failed](./spi-prepare-failed-ef6349.md)
