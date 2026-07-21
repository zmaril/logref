---
message: "return type of transition function %s is not %s"
slug: return-type-of-transition-function-is-not
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:244"
  - "postgres/src/backend/catalog/pg_aggregate.c:288"
reproduced: true
---

# `return type of transition function %s is not %s`

## What it means

An aggregate definition's transition function returns a type that does not match the aggregate's declared state type. The placeholders are the function and the expected type. The transition function must return the aggregate's state type so successive calls can chain.

## When it happens

It arises from `CREATE AGGREGATE` when the `sfunc`'s return type differs from `stype`, or when altering an aggregate leaves them inconsistent.

## How to fix

Make the transition function return exactly the declared state type (`stype`). Adjust either the function's return type or the aggregate's `stype` so they agree, and ensure the final function consumes that same state type.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE AGGREGATE repro.agg_tr(int) (SFUNC = int4eq, STYPE = int);
```

Produces:

```text
ERROR:  return type of transition function int4eq is not integer
```

## Related

- [strictness of aggregate's forward and inverse transition functions must match](./strictness-of-aggregate-s-forward-and-inverse-transition-functions-must-match.md)
- [type mismatch in hypothetical-set function](./type-mismatch-in-hypothetical-set-function.md)
