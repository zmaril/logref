---
message: "unexpected return value from trigger procedure"
slug: unexpected-return-value-from-trigger-procedure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_EXCEPTION
    code: "22000"
call_sites:
  - "postgres/src/pl/plpython/plpy_exec.c:458"
  - "postgres/src/pl/plpython/plpy_exec.c:482"
reproduced: false
---

# `unexpected return value from trigger procedure`

## What it means

A trigger function returned a value that its trigger context cannot use — for example a non-row value, or a row where the trigger type requires none.

## When it happens

It arises when a row-level `BEFORE` trigger returns something other than a `HeapTuple`/record, or when a trigger returns a row from a context that ignores it and the value is malformed. Trigger functions written in C or a PL that bypasses the normal return handling are the usual source.

## How to fix

Return the correct value for the trigger's timing and level: a row (often `NEW` or `OLD`) from a row-level `BEFORE` trigger, or `NULL`/the row as documented. Review the trigger function's `RETURN` paths so every branch yields a valid value.

## Example

*Illustrative* — a trigger returning an invalid value.

```text
ERROR:  unexpected return value from trigger procedure
```

## Related

- [unrecognized LEVEL tg_event: %u](./unrecognized-level-tg-event.md)
- [unrecognized WHEN tg_event: %u](./unrecognized-when-tg-event.md)
