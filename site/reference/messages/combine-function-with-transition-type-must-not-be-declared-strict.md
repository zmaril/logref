---
message: "combine function with transition type %s must not be declared STRICT"
slug: combine-function-with-transition-type-must-not-be-declared-strict
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:437"
  - "postgres/src/backend/executor/nodeAgg.c:4000"
reproduced: false
---

# `combine function with transition type %s must not be declared STRICT`

## What it means

A `CREATE AGGREGATE` gave a combine function that is declared `STRICT` while the aggregate uses an internal-typed transition state. The placeholder is the transition type. A strict combine function would skip NULL states and break parallel aggregation, so it is disallowed here.

## When it happens

Defining an aggregate with a `COMBINEFUNC` for parallel aggregation where that function is marked `STRICT` and the transition type requires handling NULL partial states.

## How to fix

Declare the combine function as non-strict (remove `STRICT` / `RETURNS NULL ON NULL INPUT`) and have it handle NULL transition states itself. The combine function must be prepared to receive NULL partial aggregates.

## Example

*Illustrative* — a STRICT combine function.

```text
ERROR:  combine function with transition type internal must not be declared STRICT
```

## Related

- [cannot determine transition data type](./cannot-determine-transition-data-type.md)
- [could not find compatible hash operator for operator](./could-not-find-compatible-hash-operator-for-operator.md)
