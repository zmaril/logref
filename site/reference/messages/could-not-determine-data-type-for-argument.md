---
message: "could not determine data type for argument %d"
slug: could-not-determine-data-type-for-argument
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/json.c:1011"
  - "postgres/src/backend/utils/adt/json.c:1021"
  - "postgres/src/backend/utils/fmgr/funcapi.c:2094"
reproduced: false
---

# `could not determine data type for argument %d`

## What it means

A function or construct (here JSON-building) could not infer the data type of one of its arguments. The placeholder is the argument position. When an argument is an untyped literal or `NULL` with no context, and the function needs a concrete type to proceed, the type cannot be determined.

## When it happens

Passing a bare `NULL` or an `unknown`-typed value where the function must know the type — for example in `json_build_object`/`json_build_array` or a variadic call whose element type cannot be resolved.

## How to fix

Cast the ambiguous argument to a concrete type (`NULL::text`, `$1::int`) so its type is known. When passing parameters from a client, make sure the driver sends a type, or add an explicit cast in the SQL.

## Example

*Illustrative* — an untyped argument to a JSON builder.

```sql
SELECT json_build_object('k', NULL);  -- could not determine data type for argument 2
```

## Related

- [cannot determine result data type](./cannot-determine-result-data-type.md)
- [type is only a shell](./type-is-only-a-shell-e945f0.md)
