---
message: "unexpected error status: %d"
slug: unexpected-error-status
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:1489"
  - "postgres/src/bin/pgbench/pgbench.c:4613"
reproduced: false
---

# `unexpected error status: %d`

## What it means

Internal error. Error-handling code was handed a status value it does not have a case for while processing a failure, so it could not classify the condition it was reporting.

## When it happens

It fires from low-level error or protocol handling when the status code carried alongside a failure is outside the set the handler knows about. Ordinary SQL does not reach it.

## How to fix

This is an internal consistency guard. Capture the surrounding log lines and the operation in flight and report it as a reproducible bug; the original failure it was trying to report is the more useful signal.

## Example

*Illustrative* — an unclassifiable error status.

```text
FATAL:  unexpected error status: 7
```

## Related

- [unexpected result after CommandComplete: %s](./unexpected-result-after-commandcomplete.md)
- [unexpected PQresultStatus: %d](./unexpected-pqresultstatus.md)
