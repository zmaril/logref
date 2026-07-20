---
message: "SPI_execute_plan_extended failed executing query \"%s\": %s"
slug: spi-execute-plan-extended-failed-executing-query
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2276"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3640"
reproduced: false
---

# `SPI_execute_plan_extended failed executing query "%s": %s`

## What it means

Internal error surfaced through SPI. An `SPI_execute_plan_extended` call, which runs a previously prepared SPI plan, failed. The placeholders are the query text and the underlying reason.

## When it happens

It fires when code running a prepared SPI plan hits an error during execution — the detail carries the real cause, typically an ordinary SQL runtime error in the planned query.

## How to fix

Read the attached reason and query text to find the real cause. The fix normally belongs in the PL/extension code that prepared and executed the plan — correct the query or the data it operates on.

## Example

*Illustrative* — SPI_execute_plan_extended reporting a runtime error.

```text
ERROR:  SPI_execute_plan_extended failed executing query "INSERT ...": null value in column
```

## Related

- [SPI_execute_extended failed executing query "%s": %s](./spi-execute-extended-failed-executing-query.md)
- [SPI_prepare failed for "%s"](./spi-prepare-failed-for.md)
