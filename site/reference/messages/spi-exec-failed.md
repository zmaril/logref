---
message: "SPI_exec failed: %s"
slug: spi-exec-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/matview.c:635"
  - "postgres/src/backend/commands/matview.c:658"
  - "postgres/src/backend/commands/matview.c:691"
  - "postgres/src/backend/commands/matview.c:699"
  - "postgres/src/backend/commands/matview.c:836"
  - "postgres/src/backend/commands/matview.c:847"
  - "postgres/src/backend/commands/matview.c:860"
  - "postgres/src/backend/commands/matview.c:869"
  - "postgres/src/backend/commands/matview.c:880"
reproduced: false
---

# `SPI_exec failed: %s`

## What it means

Internal error. A `SPI_exec`/`SPI_execute` call (running SQL through the Server Programming Interface) returned a failure code, reported with the SPI error name. It is used where internal machinery — for example materialized-view refresh — runs SQL via SPI and does not expect it to fail.

## When it happens

A bug or unexpected condition in code that drives SPL, or an internal SQL statement failing for a reason the caller did not anticipate. The SPI error name in the text points at the category (bad plan, copy in/out, etc.).

## How to fix

Read the SPI error name for the category. If it arises during a specific operation like `REFRESH MATERIALIZED VIEW`, look at what that operation was doing and whether an object it depends on changed. Reproducible cases with the SPI error name and the operation are worth reporting.

## Example

*Illustrative* — an internal SPI statement failing.

```text
ERROR:  SPI_exec failed: SPI_ERROR_COPY
```

## Related

- [SPI_finish failed](./spi-finish-failed-4d03d1.md)
- [materialize mode required, but it is not allowed in this context](./materialize-mode-required-but-it-is-not-allowed-in-this-context.md)
