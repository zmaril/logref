---
message: "event trigger promise is not in an event trigger function"
slug: event-trigger-promise-is-not-in-an-event-trigger-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1552"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:1558"
reproduced: false
---

# `event trigger promise is not in an event trigger function`

## What it means

Internal error in PL/pgSQL. Code tried to resolve an event-trigger-only special variable (such as `TG_EVENT`/`TG_TAG`) while not inside an event-trigger function. It is a context guard.

## When it happens

It fires from a plpgsql path that expected the event-trigger execution context and did not have it. Ordinary function calls do not reach it; it indicates an internal inconsistency.

## How to fix

This is a can't-happen guard. If you can reproduce it, capture the function and how it was invoked and report it as a bug.

## Example

*Illustrative* — event-trigger state requested outside one.

```text
ERROR:  event trigger promise is not in an event trigger function
```

## Related

- [event triggers are not supported for](./event-triggers-are-not-supported-for.md)
- [function was not called by trigger manager](./function-was-not-called-by-trigger-manager.md)
