---
message: "unrecognized dtype: %d"
slug: unrecognized-dtype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1898"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:615"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1398"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1790"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3306"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3476"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5367"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5529"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5609"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5702"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:8685"
reproduced: false
---

# `unrecognized dtype: %d`

## What it means

Internal error in PL/pgSQL. The compiler or executor encountered a datum type (`PLpgSQL_dtype`) it does not handle — the internal kind tag of a variable, row, record, or trigger datum. The placeholder is the numeric dtype. It signals a bug in PL/pgSQL or a corrupted internal structure.

## When it happens

A bug in PL/pgSQL itself, or memory corruption affecting a function's compiled tree. Ordinary PL/pgSQL code does not trigger it.

## How to fix

Treat it as a bug. Capture the function definition and the calling context and report it. If it coincides with other corruption symptoms, check hardware/memory. It is not something a change to your PL/pgSQL logic normally fixes.

## Example

*Illustrative* — an internal PL/pgSQL guard firing.

```text
ERROR:  unrecognized dtype: 4
```

## Related

- [unrecognized node type](./unrecognized-node-type.md)
- [trigger promise is not in a trigger function](./trigger-promise-is-not-in-a-trigger-function.md)
