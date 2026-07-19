---
message: "type of parameter %d (%s) does not match that when preparing the plan (%s)"
slug: type-of-parameter-does-not-match-that-when-preparing-the-plan
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/executor/execCurrent.c:278"
  - "postgres/src/backend/executor/execExprInterp.c:3101"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:6899"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:6939"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:6979"
reproduced: false
---

# `type of parameter %d (%s) does not match that when preparing the plan (%s)`

## What it means

A prepared plan was re-executed with a parameter whose type differs from the type used when the plan was prepared. The placeholders are the parameter number, the new type, and the original type. A cached plan is tied to its parameter types and cannot be reused with different ones.

## When it happens

Re-running a prepared statement or a cached plan (including PL/pgSQL's plan cache and portal/cursor reuse) with a parameter bound to a different type than the first execution established.

## How to fix

Bind each parameter with the same type across executions. If the parameter's type genuinely changes, re-prepare the statement (`DEALLOCATE` then `PREPARE` again) so a fresh plan is built. In client libraries, avoid reusing one prepared statement for differently-typed inputs.

## Example

*Illustrative* — a parameter type changed between executions.

```text
ERROR:  type of parameter 1 (text) does not match that when preparing the plan (integer)
```

## Related

- [there is no parameter](./there-is-no-parameter.md)
- [argument declared is not consistent with argument declared](./argument-declared-is-not-consistent-with-argument-declared.md)
