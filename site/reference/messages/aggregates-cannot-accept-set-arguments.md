---
message: "aggregates cannot accept set arguments"
slug: aggregates-cannot-accept-set-arguments
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:284"
reproduced: true
---

# `aggregates cannot accept set arguments`

## What it means

A `CREATE AGGREGATE` declared an argument of a pseudo-type that represents a set, or the aggregate was invoked with a set-valued argument, which aggregates cannot accept.

## When it happens

It occurs when an aggregate's argument type is one that stands for a set rather than a single value, or when a set-returning expression is used where an aggregate expects a scalar argument.

## How to fix

Give the aggregate scalar argument types and pass scalar values. Expand any set into rows first (in the `FROM` clause) and aggregate over those rows, rather than passing a set as a single argument.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE AGGREGATE repro.agg_set(SETOF int) (SFUNC = int4pl, STYPE = int);
```

Produces:

```text
ERROR:  aggregates cannot accept set arguments
```

## Related

- [aggregates cannot return sets](./aggregates-cannot-return-sets.md)
- [aggregate function calls cannot contain set-returning function calls](./aggregate-function-calls-cannot-contain-set-returning-function-calls.md)
