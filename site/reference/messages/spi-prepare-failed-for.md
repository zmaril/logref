---
message: "SPI_prepare failed for \"%s\""
slug: spi-prepare-failed-for
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:642"
  - "postgres/src/backend/utils/adt/ruleutils.c:835"
reproduced: false
---

# `SPI_prepare failed for "%s"`

## What it means

Internal error surfaced through SPI. Preparing a specific named query through SPI failed. The placeholder is the query (or its identifier). It is the variant that names the query rather than carrying a reason string.

## When it happens

It fires from PL/extension code preparing an SPI plan for the named query when parsing or planning it fails.

## How to fix

Identify the named query and correct it in the PL/extension code that prepares it. A companion error or the server log usually carries the specific parse/plan reason.

## Example

*Illustrative* — SPI_prepare failing for a named query.

```text
ERROR:  SPI_prepare failed for "SELECT bad syntax"
```

## Related

- [SPI_prepare failed: %s](./spi-prepare-failed-b6db8e.md)
- [SPI_execute_extended failed executing query "%s": %s](./spi-execute-extended-failed-executing-query.md)
