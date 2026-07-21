---
message: "EXPLAIN EXECUTE does not support variable-result cached plans"
slug: explain-execute-does-not-support-variable-result-cached-plans
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/prepare.c:610"
reproduced: false
---

# `EXPLAIN EXECUTE does not support variable-result cached plans`

## What it means

An internal guard. `EXPLAIN EXECUTE` cannot explain a prepared statement whose cached plan does not have a fixed result-column shape, because it needs a stable result description.

## When it happens

It fires from `EXPLAIN EXECUTE stmt` when the prepared statement's underlying plan produces a result row description that can vary. In ordinary SQL this shape is not produced, so reaching it is unexpected.

## How to fix

This is an internal invariant, not a user knob. Deallocate and re-prepare the statement, or explain the command directly (`EXPLAIN <the SQL>`) instead of through `EXECUTE`. Report it with the statement if it recurs, since result shapes are normally fixed at prepare time.

## Example

*Illustrative* — the message as logged.

```
ERROR:  EXPLAIN EXECUTE does not support variable-result cached plans
```

## Related

- [EXECUTE does not support variable-result cached plans](./execute-does-not-support-variable-result-cached-plans.md)
- [EXECUTE of transaction commands is not implemented](./execute-of-transaction-commands-is-not-implemented.md)
