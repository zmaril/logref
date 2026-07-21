---
message: "consistency check on SPI tuple count failed"
slug: consistency-check-on-spi-tuple-count-failed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/spi.c:2940"
  - "postgres/src/backend/executor/spi.c:3043"
reproduced: false
---

# `consistency check on SPI tuple count failed`

## What it means

Internal error. The Server Programming Interface (SPI) compared the number of tuples it processed against its own running count and they disagreed. It is a consistency check that guards SPI's bookkeeping, used by PL languages and internal query execution.

## When it happens

It should not occur through ordinary SQL or PL code. Reaching it points to an internal inconsistency in SPI execution, not to anything in your function.

## How to fix

Treat it as an internal bug. Capture the PL function or command that triggered it and report it. There is no reliable user-side workaround, though isolating the specific query SPI was running helps a diagnosis.

## Example

*Illustrative* — emitted internally by SPI.

```text
ERROR:  consistency check on SPI tuple count failed
```

## Related

- [CommitTransactionCommand: unexpected state](./committransactioncommand-unexpected-state.md)
- [control reached end of trigger procedure without return](./control-reached-end-of-trigger-procedure-without-return.md)
