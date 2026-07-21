---
message: "variadic parameter must be last"
slug: variadic-parameter-must-be-last
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:281"
  - "postgres/src/backend/catalog/pg_proc.c:285"
  - "postgres/src/backend/catalog/pg_proc.c:292"
reproduced: false
---

# `variadic parameter must be last`

## What it means

A function definition placed the variadic parameter somewhere other than the final position. A variadic parameter absorbs all trailing arguments, so it has to be the last parameter in the signature.

## When it happens

Writing `CREATE FUNCTION` with a `VARIADIC` parameter followed by more parameters, so the variadic is not the final one in the list.

## How to fix

Move the `VARIADIC` parameter to the end of the parameter list. A function can have at most one variadic parameter, and it must come last, after all fixed parameters.

## Example

*Illustrative* — a variadic parameter not placed last.

```sql
CREATE FUNCTION f(VARIADIC a int[], b text) ...;  -- variadic must be last
```

## Related

- [variadic parameter must be an array](./variadic-parameter-must-be-an-array.md)
- [argument list length must be exactly](./argument-list-length-must-be-exactly.md)
