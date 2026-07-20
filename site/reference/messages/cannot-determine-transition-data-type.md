---
message: "cannot determine transition data type"
slug: cannot-determine-transition-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:142"
  - "postgres/src/backend/catalog/pg_aggregate.c:156"
reproduced: false
---

# `cannot determine transition data type`

## What it means

A `CREATE AGGREGATE` used a polymorphic transition type (such as `anyelement` or `anyarray`) that cannot be resolved from the aggregate's argument types. An aggregate's state type must be a concrete type or resolvable from its inputs.

## When it happens

Defining an aggregate whose `STYPE` is polymorphic while the argument types do not give Postgres enough information to pin the transition type to a concrete one.

## How to fix

Declare a concrete transition type, or add polymorphic argument types that let Postgres infer the state type. Ensure any polymorphism in `STYPE` is matched by polymorphism in the argument list so the transition type can be determined.

## Example

*Illustrative* — an unresolvable polymorphic state type.

```text
ERROR:  cannot determine transition data type
DETAIL:  An aggregate using a polymorphic transition type must have at least one polymorphic argument.
```

## Related

- [combine function with transition type must not be declared STRICT](./combine-function-with-transition-type-must-not-be-declared-strict.md)
- [cannot change routine kind](./cannot-change-routine-kind.md)
