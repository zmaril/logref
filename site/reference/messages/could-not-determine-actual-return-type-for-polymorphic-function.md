---
message: "could not determine actual return type for polymorphic function \"%s\""
slug: could-not-determine-actual-return-type-for-polymorphic-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_comp.c:423"
reproduced: false
---

# `could not determine actual return type for polymorphic function "%s"`

## What it means

A PL/pgSQL function with a polymorphic return type could not resolve which concrete type to return in this call. The `%s` names the function. The return type stayed unresolved.

## When it happens

It happens when a function returning `anyelement`/`anyarray` and friends is called without enough type information in its arguments to determine the result type.

## How to fix

Make sure at least one argument pins the polymorphic family to a concrete type, casting an input if needed (for example `NULL::int`). The return type is derived from the argument types, so they must be unambiguous.

## Example

*Illustrative* — a polymorphic return with untyped inputs.

```sql
SELECT my_poly(NULL);
-- ERROR:  could not determine actual return type for polymorphic function "my_poly"
```

## Related

- [could not determine actual argument type for polymorphic function](./could-not-determine-actual-argument-type-for-polymorphic-function.md)
- [could not determine actual result type for function declared to return type](./could-not-determine-actual-result-type-for-function-declared-to-return-type.md)
