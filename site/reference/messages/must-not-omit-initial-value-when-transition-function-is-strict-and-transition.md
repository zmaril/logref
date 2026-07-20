---
message: "must not omit initial value when transition function is strict and transition type is not compatible with input type"
slug: must-not-omit-initial-value-when-transition-function-is-strict-and-transition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:264"
  - "postgres/src/backend/catalog/pg_aggregate.c:307"
reproduced: false
---

# `must not omit initial value when transition function is strict and transition type is not compatible with input type`

## What it means

A `CREATE AGGREGATE` left out the initial state value (`INITCOND`), but its transition function is strict and the transition (state) type is not compatible with the input type. In that combination the aggregate could never establish an initial state, so the definition is rejected.

## When it happens

It arises defining a custom aggregate with a `STRICT` transition function and a state type that differs from the input type, without providing an `INITCOND`. A strict transition function returns NULL on NULL input, so with no initial value and incompatible types the state can never be seeded.

## How to fix

Provide an `INITCOND` for the aggregate, make the transition function non-strict so it can handle the first (NULL-state) call, or use a state type compatible with the input type so the first input can seed the state. Choose the option that matches your aggregate's semantics.

## Example

*Illustrative* — a strict transition with incompatible state type and no INITCOND.

```sql
CREATE AGGREGATE a(int) (SFUNC = f, STYPE = text);  -- needs INITCOND or non-strict SFUNC
```

## Related

- [must be used to call a parameterless aggregate function](./must-be-used-to-call-a-parameterless-aggregate-function.md)
- [must not return a set](./must-not-return-a-set.md)
