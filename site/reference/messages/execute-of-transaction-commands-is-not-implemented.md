---
message: "EXECUTE of transaction commands is not implemented"
slug: execute-of-transaction-commands-is-not-implemented
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4629"
reproduced: false
---

# `EXECUTE of transaction commands is not implemented`

## What it means

A PL/pgSQL `EXECUTE` ran a transaction-control command such as `BEGIN`, `COMMIT`, or `ROLLBACK` in a context where it is not allowed. Dynamic `EXECUTE` cannot run transaction statements this way.

## When it happens

It fires when the string passed to PL/pgSQL `EXECUTE` is a transaction-control command, or when transaction control is attempted where the calling context forbids it (for example inside a function rather than a procedure).

## How to fix

Use PL/pgSQL's own `COMMIT` and `ROLLBACK` statements directly (not through `EXECUTE`), and only in a procedure called by `CALL`, not in a function. Functions run inside the caller's transaction and cannot control it. Restructure the logic so transaction boundaries live in a procedure or in the top-level application.

## Example

*Illustrative* — use direct COMMIT in a procedure, not EXECUTE.

```sql
-- inside a PROCEDURE:
COMMIT;
```

## Related

- [EXECUTE of SELECT ... INTO is not implemented](./execute-of-select-into-is-not-implemented.md)
- [EXECUTE does not support variable-result cached plans](./execute-does-not-support-variable-result-cached-plans.md)
