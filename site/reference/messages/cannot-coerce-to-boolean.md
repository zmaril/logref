---
message: "cannot coerce %s to boolean"
slug: cannot-coerce-to-boolean
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2008"
reproduced: false
---

# `cannot coerce %s to boolean`

## What it means

A jsonpath or SQL/JSON expression tried to interpret a value as a boolean when it is not one. The value's type does not convert to boolean in this context. The placeholder is the value or item.

## When it happens

It occurs in SQL/JSON path evaluation when a predicate or operation expects a boolean but receives a value of another type.

## How to fix

Ensure the expression produces a boolean where one is required — compare or test values explicitly rather than relying on an implicit conversion. Check the jsonpath so boolean context receives boolean input.

## Example

*Illustrative* — a non-boolean in boolean context.

```text
ERROR:  cannot coerce "5" to boolean
```

## Related

- [cannot coerce to int](./cannot-coerce-to-int.md)
- [cannot coerce to double](./cannot-coerce-to-double.md)
