---
message: "SPI_cursor_open(\"%s\") failed"
slug: spi-cursor-open-failed-29c557
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/tsquery_rewrite.c:311"
  - "postgres/src/backend/utils/adt/tsvector_op.c:2563"
  - "postgres/src/backend/utils/adt/xml.c:3123"
  - "postgres/src/backend/utils/adt/xml.c:3204"
reproduced: false
---

# `SPI_cursor_open("%s") failed`

## What it means

Internal error. Server code running SQL through the SPI (Server Programming Interface) — used by PL/pgSQL, extensions, and some built-in functions — tried to open a cursor over a query and the open failed. The placeholder is the query text. SPI callers treat a cursor-open failure as a `can't happen` condition and abort.

## When it happens

It surfaces from a specific SPI-using code path (here text-search query rewriting). It generally reflects an internal problem or an out-of-resources condition during cursor setup rather than a mistake in your SQL.

## How to fix

Note the operation that triggered it and look for an accompanying, more specific error that explains the underlying cause (resource exhaustion, a broken query the caller assembled). Capture a reproducer and report it; there is usually no user-side setting to change.

## Example

*Illustrative* — emitted internally by an SPI caller.

```text
ERROR:  SPI_cursor_open("...") failed
```

## Related

- [SPI_prepare failed](./spi-prepare-failed-ef6349.md)
- [SPI_finish failed](./spi-finish-failed-57045c.md)
