---
message: "control reached end of trigger procedure without RETURN"
slug: control-reached-end-of-trigger-procedure-without-return
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_S_R_E_FUNCTION_EXECUTED_NO_RETURN_STATEMENT
    code: "2F005"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1058"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1216"
reproduced: false
---

# `control reached end of trigger procedure without RETURN`

## What it means

A PL/pgSQL trigger function ran off the end of its body without executing a `RETURN`. A trigger function must return a row (or NULL) to tell Postgres how to proceed, and this one returned nothing.

## When it happens

A trigger function whose code path can reach the end without a `RETURN` — for example a conditional branch that lacks a return statement, or a body that omits the final `RETURN NEW`/`RETURN OLD`.

## How to fix

Ensure every path through the trigger function ends in an explicit `RETURN` — typically `RETURN NEW` for `BEFORE`/row triggers that keep the row, `RETURN OLD`, or `RETURN NULL` to skip the operation. Add the missing `RETURN` to the branch that reaches the end.

## Example

*Illustrative* — a trigger path with no RETURN.

```text
ERROR:  control reached end of trigger procedure without RETURN
```

## Related

- [can only be called in a table_rewrite event trigger function](./can-only-be-called-in-a-table-rewrite-event-trigger-function.md)
- [cannot set generated column](./cannot-set-generated-column.md)
