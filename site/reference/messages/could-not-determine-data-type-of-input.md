---
message: "could not determine data type of input"
slug: could-not-determine-data-type-of-input
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6044"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6083"
reproduced: false
---

# `could not determine data type of input`

## What it means

An array or similar constructor received an input whose data type could not be determined. The value was an untyped placeholder with no surrounding context to resolve its type, so Postgres could not proceed.

## When it happens

Building an array or comparable structure from an argument that has no determinable type — commonly an untyped `NULL` or an unbound parameter.

## How to fix

Cast the ambiguous input to a concrete type, for example `NULL::int` or `$1::text`. Provide typed values so the constructor can infer the result type.

## Example

*Illustrative* — an untyped element in an array constructor.

```sql
SELECT array_append(ARRAY[]::int[], NULL);  -- vs. an untyped context
-- ERROR:  could not determine data type of input
```

## Related

- [could not determine data type of format input](./could-not-determine-data-type-of-format-input.md)
- [could not determine data type of parameter](./could-not-determine-data-type-of-parameter.md)
