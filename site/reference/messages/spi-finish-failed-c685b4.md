---
message: "SPI_finish failed: %s"
slug: spi-finish-failed-c685b4
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_handler.c:302"
  - "postgres/src/pl/plpgsql/src/pl_handler.c:427"
  - "postgres/src/pl/plpgsql/src/pl_handler.c:544"
reproduced: false
---

# `SPI_finish failed: %s`

## What it means

Internal error. PL/pgSQL handler code called the server programming interface's finish routine and it reported failure. The message carries the returned status. It is a consistency check on the SPI session lifecycle.

## When it happens

It should not occur in normal function execution. Reaching it points to an internal inconsistency in how an SPI session was opened and closed rather than to your function's logic.

## How to fix

Treat it as an internal bug. Note the function being executed and the returned status, capture the surrounding context, and report it. There is no application-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — a failed SPI finish.

```text
ERROR:  SPI_finish failed: SPI_ERROR_UNCONNECTED
```

## Related

- [spi execute snapshot returned](./spi-execute-snapshot-returned.md)
- [spi prepare returned for](./spi-prepare-returned-for.md)
