---
message: "aggregate transition data type cannot be %s"
slug: aggregate-transition-data-type-cannot-be
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:345"
  - "postgres/src/backend/commands/aggregatecmds.c:386"
reproduced: false
---

# `aggregate transition data type cannot be %s`

## What it means

An aggregate definition used a transition (state) data type that is not allowed as such. Certain pseudo-types cannot serve as an aggregate's state type because a state value must be storable and passable between transition calls.

## When it happens

Running `CREATE AGGREGATE` with an `STYPE` set to a disallowed type — for example a pseudo-type that cannot hold a real state value — usually when defining a custom aggregate.

## How to fix

Choose a valid transition type for the aggregate's state. Use a concrete type, or `internal` when the state is a C-level structure managed by the transition function. Consult the `CREATE AGGREGATE` documentation for which types are permitted as `STYPE`.

## Example

*Illustrative* — a disallowed aggregate state type.

```sql
CREATE AGGREGATE a(int) (SFUNC = f, STYPE = anyelement);  -- not allowed as a state type
```

## Related

- [aggregate needs to have compatible input type and transition type](./aggregate-needs-to-have-compatible-input-type-and-transition-type.md)
- [unsafe use of pseudo-type internal](./unsafe-use-of-pseudo-type-internal.md)
