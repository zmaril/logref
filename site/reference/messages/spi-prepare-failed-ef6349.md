---
message: "SPI_prepare(\"%s\") failed"
slug: spi-prepare-failed-ef6349
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/tsquery_rewrite.c:308"
  - "postgres/src/backend/utils/adt/tsvector_op.c:2559"
  - "postgres/src/backend/utils/adt/xml.c:3120"
  - "postgres/src/backend/utils/adt/xml.c:3201"
reproduced: false
---

# `SPI_prepare("%s") failed`

## What it means

Internal error. Server code running SQL through SPI called `SPI_prepare()` to plan a statement and it failed. The placeholder is the query text. The SPI caller expected the prepare to succeed and treats its failure as a `can't happen` condition.

## When it happens

It surfaces from a specific SPI-using code path (here text-search query rewriting). It usually means the query the caller assembled could not be planned, or a resource problem occurred during planning.

## How to fix

Look for a more specific error emitted alongside it that names the real planning failure. If it correlates with a particular text-search configuration or input, capture that input and report it; there is generally no user-side knob for this internal path.

## Example

*Illustrative* — emitted internally by an SPI caller.

```text
ERROR:  SPI_prepare("...") failed
```

## Related

- [SPI_cursor_open failed](./spi-cursor-open-failed-29c557.md)
- [SPI_finish failed](./spi-finish-failed-57045c.md)
