---
message: "ERRORDATA_STACK_SIZE exceeded"
slug: errordata-stack-size-exceeded
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/utils/error/elog.c:783"
reproduced: false
---

# `ERRORDATA_STACK_SIZE exceeded`

## What it means

An internal guard in the error-reporting machinery. PostgreSQL keeps a fixed-size stack of in-progress `ereport`/`elog` calls; this fires when that stack would overflow, which usually means error handling recursed into itself.

## When it happens

It fires when too many errors are raised while an error is already being processed — for example an error inside an error-context callback, or a fault that keeps re-triggering during cleanup. It is a backstop against unbounded recursion in the logging path.

## How to fix

This is an internal invariant, not a user error, and it escalates to a PANIC because error handling itself is broken. Capture the log around it and any core dump. If it is reproducible, it points at a bug in an extension's error callback or in server code; report it with the recipe. There is no configuration knob for the stack size.

## Example

*Illustrative* — the message as logged.

```
PANIC:  ERRORDATA_STACK_SIZE exceeded
```

## Related

- [expected just one rule action](./expected-just-one-rule-action.md)
- [extParam set of initplan is empty](./extparam-set-of-initplan-is-empty.md)
