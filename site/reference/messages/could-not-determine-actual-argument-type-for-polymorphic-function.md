---
message: "could not determine actual argument type for polymorphic function \"%s\""
slug: could-not-determine-actual-argument-type-for-polymorphic-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/cache/funccache.c:362"
reproduced: false
---

# `could not determine actual argument type for polymorphic function "%s"`

## What it means

A call to a function with polymorphic arguments (such as `anyelement` or `anyarray`) did not give PostgreSQL enough information to pin down the concrete argument type. The `%s` names the function. The polymorphic type stayed unresolved.

## When it happens

It happens when a polymorphic function is called in a context where the actual types cannot be inferred — for example passing an untyped `NULL` where the concrete type must come from an argument.

## How to fix

Cast the ambiguous argument to the concrete type you intend (`NULL::integer`, `'{}'::int[]`), so PostgreSQL can resolve the polymorphic type. Every polymorphic argument must be pinned by at least one concrete input.

## Example

*Illustrative* — an untyped NULL leaving the type unresolved.

```sql
SELECT array_append(NULL, 1);
-- ERROR:  could not determine actual argument type for polymorphic function "array_append"
```

## Related

- [could not determine actual return type for polymorphic function](./could-not-determine-actual-return-type-for-polymorphic-function.md)
- [could not determine actual type of argument declared](./could-not-determine-actual-type-of-argument-declared.md)
