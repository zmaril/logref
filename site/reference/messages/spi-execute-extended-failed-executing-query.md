---
message: "SPI_execute_extended failed executing query \"%s\": %s"
slug: spi-execute-extended-failed-executing-query
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3683"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4635"
reproduced: false
---

# `SPI_execute_extended failed executing query "%s": %s`

## What it means

Internal error surfaced through SPI. An `SPI_execute_extended` call, used by PL languages/extensions to run a query, failed. The placeholders are the query text and the underlying reason.

## When it happens

It fires when code calling SPI executes a query that errors — the detail carries the real cause, which is usually an ordinary SQL error inside the executed query rather than an SPI defect.

## How to fix

Read the attached reason and the query text: they identify the real problem. The fix normally belongs in the PL/extension code that built and ran the query — correct the SQL or the data it depends on.

## Example

*Illustrative* — SPI_execute_extended reporting a query error.

```text
ERROR:  SPI_execute_extended failed executing query "UPDATE ...": division by zero
```

## Related

- [SPI_execute_plan_extended failed executing query "%s": %s](./spi-execute-plan-extended-failed-executing-query.md)
- [SPI_cursor_open() failed: %s](./spi-cursor-open-failed-14613b.md)
