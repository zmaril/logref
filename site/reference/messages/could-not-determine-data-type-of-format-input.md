---
message: "could not determine data type of format() input"
slug: could-not-determine-data-type-of-format-input
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/varlena.c:4938"
  - "postgres/src/backend/utils/adt/varlena.c:4995"
reproduced: false
---

# `could not determine data type of format() input`

## What it means

The `format()` function received an argument whose data type it could not determine. This arises when an argument is an untyped placeholder (such as a bare `NULL` or a parameter) with no context to resolve its type.

## When it happens

Calling `format()` with an argument that has no determinable type — for instance an untyped `NULL` or a parameter marker the planner cannot pin to a type.

## How to fix

Cast the ambiguous argument to a concrete type, for example `NULL::text` or `$1::int`. Give `format()` arguments whose types are known so it can render them.

## Example

*Illustrative* — an untyped argument to format().

```sql
SELECT format('%s', NULL);
-- ERROR:  could not determine data type of format() input
```

## Related

- [could not determine data type of input](./could-not-determine-data-type-of-input.md)
- [could not determine data type of parameter](./could-not-determine-data-type-of-parameter.md)
