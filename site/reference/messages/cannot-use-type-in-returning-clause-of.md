---
message: "cannot use type %s in RETURNING clause of %s"
slug: cannot-use-type-in-returning-clause-of
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4268"
  - "postgres/src/backend/parser/parse_expr.c:4389"
reproduced: false
---

# `cannot use type %s in RETURNING clause of %s`

## What it means

A `RETURNING` clause produced a value of a type that is not allowed in the `RETURNING` list of that command. The placeholders are the type and the command. Certain pseudo-types or context-bound types cannot be returned to the client this way.

## When it happens

Writing a `RETURNING` expression that yields an unsupported type — for example a set-returning or internal-only type — in an `INSERT`/`UPDATE`/`DELETE`/`MERGE`.

## How to fix

Return a concrete, client-representable type instead. Cast or reshape the `RETURNING` expression so it produces a supported column type, or move the computation out of `RETURNING`.

## Example

*Illustrative* — an unsupported type in RETURNING.

```text
ERROR:  cannot use type internal in RETURNING clause of INSERT
```

## Related

- [could not coerce expression to the RETURNING type](./could-not-coerce-expression-to-the-returning-type.md)
- [cannot cast behavior expression of type to](./cannot-cast-behavior-expression-of-type-to.md)
