---
message: "cannot cast behavior expression of type %s to %s"
slug: cannot-cast-behavior-expression-of-type-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CANNOT_COERCE
    code: "42846"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4999"
  - "postgres/src/backend/parser/parse_expr.c:5008"
reproduced: false
---

# `cannot cast behavior expression of type %s to %s`

## What it means

A behavior expression (from an SQL/JSON or similar constructor) could not be coerced from its actual type to the type the surrounding construct requires. The placeholders are the source and target types. No implicit cast exists between them in this context.

## When it happens

Supplying an `ON ERROR` / `ON EMPTY` default value or a similar behavior expression whose type does not match the column or result type the construct produces.

## How to fix

Give the behavior expression a value of the expected type, or add an explicit cast to it. Match the default or fallback value's type to the type the JSON or table construct returns.

## Example

*Illustrative* — a default whose type cannot be cast.

```text
ERROR:  cannot cast behavior expression of type text to integer
```

## Related

- [cannot use type in RETURNING clause of](./cannot-use-type-in-returning-clause-of.md)
- [could not coerce expression to the RETURNING type](./could-not-coerce-expression-to-the-returning-type.md)
