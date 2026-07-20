---
message: "invalid portal in SPI cursor operation"
slug: invalid-portal-in-spi-cursor-operation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/spi.c:1866"
  - "postgres/src/backend/executor/spi.c:3014"
reproduced: false
---

# `invalid portal in SPI cursor operation`

## What it means

Internal error. An SPI cursor operation was handed a portal handle that is not a valid open SPI cursor. It is a consistency guard in the Server Programming Interface used by PL/pgSQL and C functions.

## When it happens

It fires when SPI cursor code (fetch/move/close) is called with a portal that was never opened as an SPI cursor or was already closed. Ordinary PL/pgSQL cursor use does not surface it; it points to a bug in C code using SPI directly.

## How to fix

This is a can't-happen guard for normal SQL. If a custom C function or extension drives SPI cursors, check that it opens the cursor before fetching and does not reuse a closed handle. Otherwise capture the case and report it.

## Example

*Illustrative* — an SPI cursor call on an invalid portal.

```text
ERROR:  invalid portal in SPI cursor operation
```

## Related

- [open cursor failed during argument processing](./open-cursor-failed-during-argument-processing.md)
- [lastval is not yet defined in this session](./lastval-is-not-yet-defined-in-this-session.md)
