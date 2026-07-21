---
message: "could not determine actual type of argument declared %s"
slug: could-not-determine-actual-type-of-argument-declared
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/executor/functions.c:291"
reproduced: false
---

# `could not determine actual type of argument declared %s`

## What it means

A SQL-language function's argument was declared with a polymorphic type that could not be resolved to a concrete type for this call. The `%s` shows the declared type. The argument's real type stayed unknown.

## When it happens

It happens when a SQL function using polymorphic argument types is called without enough information to pin those types down — for example untyped literals or NULLs supplied for polymorphic parameters.

## How to fix

Cast the arguments to concrete types so the polymorphic declaration resolves. Each polymorphic argument needs an input whose type is unambiguous.

## Example

*Illustrative* — an unresolved polymorphic argument in a SQL function.

```text
ERROR:  could not determine actual type of argument declared anyelement
```

## Related

- [could not determine actual argument type for polymorphic function](./could-not-determine-actual-argument-type-for-polymorphic-function.md)
- [could not determine polymorphic type because input has type](./could-not-determine-polymorphic-type-because-input-has-type-ede818.md)
