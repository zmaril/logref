---
message: "SPI_finish failed"
slug: spi-finish-failed-4d03d1
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/matview.c:884"
  - "postgres/src/backend/utils/adt/ri_triggers.c:614"
  - "postgres/src/backend/utils/adt/ri_triggers.c:779"
  - "postgres/src/backend/utils/adt/ri_triggers.c:1055"
  - "postgres/src/backend/utils/adt/ri_triggers.c:1157"
  - "postgres/src/backend/utils/adt/ri_triggers.c:1274"
  - "postgres/src/backend/utils/adt/ri_triggers.c:1502"
  - "postgres/src/backend/utils/adt/ri_triggers.c:1950"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2164"
  - "postgres/src/backend/utils/adt/ruleutils.c:676"
  - "postgres/src/backend/utils/adt/ruleutils.c:871"
  - "postgres/src/pl/plpython/plpy_exec.c:181"
  - "postgres/src/pl/plpython/plpy_exec.c:445"
reproduced: false
---

# `SPI_finish failed`

## What it means

Internal error. A call to `SPI_finish()` (the Server Programming Interface, used by PL languages and some C functions to run SQL) returned a failure. The most common underlying cause is calling `SPI_finish` without a matching successful `SPI_connect`, meaning the SPI stack is in an unexpected state.

## When it happens

A bug in a C function, PL handler, or extension that misuses the SPI API — for example unbalanced connect/finish calls, or finishing after an error unwound the SPI context. Ordinary SQL does not reach it.

## How to fix

Suspect the C/extension code that uses SPI. Ensure every `SPI_connect` is balanced by exactly one `SPI_finish` and that error paths do not double-finish. If a third-party extension raises it, report it with the reproducing steps. It is a programming error in the caller, not a data problem.

## Example

*Illustrative* — unbalanced SPI calls in an extension.

```text
ERROR:  SPI_finish failed: SPI_ERROR_UNCONNECTED
```

## Related

- [SPI_exec failed](./spi-exec-failed.md)
- [materialize mode required, but it is not allowed in this context](./materialize-mode-required-but-it-is-not-allowed-in-this-context.md)
