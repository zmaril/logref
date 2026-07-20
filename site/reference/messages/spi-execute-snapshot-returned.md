---
message: "SPI_execute_snapshot returned %s"
slug: spi-execute-snapshot-returned
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ri_triggers.c:1891"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2130"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2767"
reproduced: false
---

# `SPI_execute_snapshot returned %s`

## What it means

Internal error. Referential-integrity trigger code ran a query through the server programming interface with a specific snapshot and received a result code it did not expect. The message names the returned code. It is a consistency check inside foreign-key enforcement.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency in the referential-integrity machinery rather than to your data or constraints as such.

## How to fix

Treat it as an internal bug. Capture the operation that triggered it — the tables and foreign key involved — and report it with the returned code. There is no data-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an unexpected result code in RI enforcement.

```text
ERROR:  SPI_execute_snapshot returned SPI_ERROR_TRANSACTION
```

## Related

- [spi prepare returned for](./spi-prepare-returned-for.md)
- [spi finish failed](./spi-finish-failed-c685b4.md)
