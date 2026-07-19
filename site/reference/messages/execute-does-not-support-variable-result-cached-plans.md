---
message: "EXECUTE does not support variable-result cached plans"
slug: execute-does-not-support-variable-result-cached-plans
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/prepare.c:172"
reproduced: false
---

# `EXECUTE does not support variable-result cached plans`

## What it means

An internal guard around prepared-statement execution. The `EXECUTE` machinery cannot run a cached plan whose result columns are not fixed, because it needs a stable result shape to return rows.

## When it happens

It fires when executing a prepared statement whose underlying command produces a result row description that can vary between plans. In normal SQL use the planner and parser prevent this, so reaching it is unexpected.

## How to fix

This is an internal invariant rather than a user knob. If you hit it from application code, deallocate and re-prepare the statement, or run the command directly instead of through a prepared statement. Capture the statement text and report it if it recurs, since the result shape is normally fixed at prepare time.

## Example

*Illustrative* — the message as logged.

```
ERROR:  EXECUTE does not support variable-result cached plans
```

## Related

- [EXPLAIN EXECUTE does not support variable-result cached plans](./explain-execute-does-not-support-variable-result-cached-plans.md)
- [EXECUTE of transaction commands is not implemented](./execute-of-transaction-commands-is-not-implemented.md)
