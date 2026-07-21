---
message: "cannot determine result data type"
slug: cannot-determine-result-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:496"
  - "postgres/src/backend/catalog/pg_proc.c:217"
  - "postgres/src/backend/catalog/pg_proc.c:251"
reproduced: false
---

# `cannot determine result data type`

## What it means

A polymorphic function or construct did not receive enough type information to pin down its result type. Functions declared to return `anyelement`, `anyarray`, `anyrange`, and friends infer their result from the argument types; when the arguments do not determine it, the result type is undefined.

## When it happens

Calling a polymorphic function with arguments that leave the result ambiguous — for example passing only `NULL`s or `unknown`-typed literals — or defining an aggregate/function whose declared polymorphic result cannot be resolved from its inputs.

## How to fix

Give the resolver something to work with: cast the arguments to concrete types (`NULL::int`, `'x'::text`) so the polymorphic result can be inferred. When defining such a function, ensure at least one argument carries the type that determines the result, per the polymorphic type rules.

## Example

*Illustrative* — untyped arguments to a polymorphic function.

```sql
SELECT array_append(NULL, NULL);  -- cannot determine result data type
```

## Related

- [could not determine data type for argument](./could-not-determine-data-type-for-argument.md)
- [argument declared is not an array but type](./argument-declared-is-not-an-array-but-type.md)
