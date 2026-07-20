---
message: "SPI_prepare returned %s for %s"
slug: spi-prepare-returned-for
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ri_triggers.c:1873"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2112"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2635"
reproduced: false
---

# `SPI_prepare returned %s for %s`

## What it means

Internal error. Referential-integrity code prepared a query through the server programming interface and received an unexpected status instead of a usable plan. The message names the status and the query context. It is a consistency check inside foreign-key enforcement.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency in the referential-integrity machinery rather than to your constraints or data.

## How to fix

Treat it as an internal bug. Capture the tables and foreign key involved along with the reported status, and report it. There is no data-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an unexpected prepare status in RI code.

```text
ERROR:  SPI_prepare returned SPI_ERROR_ARGUMENT for ...
```

## Related

- [spi execute snapshot returned](./spi-execute-snapshot-returned.md)
- [spi finish failed](./spi-finish-failed-c685b4.md)
