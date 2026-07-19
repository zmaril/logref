---
message: "trigger promise is not in a trigger function"
slug: trigger-promise-is-not-in-a-trigger-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1436"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1445"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1458"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1469"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1484"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1492"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1501"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1510"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1518"
reproduced: false
---

# `trigger promise is not in a trigger function`

## What it means

Internal error in PL/pgSQL. Code tried to resolve a trigger-specific variable (`NEW`, `OLD`, `TG_*`) while not actually running inside a trigger function. The "promise" is PL/pgSQL's lazy binding of those variables, and it was evaluated in the wrong context.

## When it happens

A bug in PL/pgSQL or a corrupted function tree, or a function that references trigger variables but is somehow being executed outside a trigger. Ordinary trigger functions do not trigger it.

## How to fix

Treat it as a bug. Ensure trigger variables are only used in functions actually called as triggers (declared `RETURNS trigger` and attached with `CREATE TRIGGER`). If the function is a proper trigger and this still fires, capture it and report it. It is not a normal user-facing condition.

## Example

*Illustrative* — an internal PL/pgSQL trigger-binding guard.

```text
ERROR:  trigger promise is not in a trigger function
```

## Related

- [unrecognized dtype](./unrecognized-dtype.md)
- [type %s is not composite](./type-is-not-composite.md)
