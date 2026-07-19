---
message: "could not coerce FOR PORTION OF %s bound from %s to %s"
slug: could-not-coerce-for-portion-of-bound-from-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/analyze.c:1473"
  - "postgres/src/backend/parser/analyze.c:1481"
reproduced: false
---

# `could not coerce FOR PORTION OF %s bound from %s to %s`

## What it means

A `FOR PORTION OF` clause (temporal update/delete over a range) supplied a bound value that could not be coerced from its type to the range's element type. The placeholders are the bound label and the source and target types. The bound must match the period's type.

## When it happens

Writing a temporal `UPDATE`/`DELETE ... FOR PORTION OF period FROM x TO y` where `x` or `y` has a type that does not cast to the period column's element type.

## How to fix

Supply the `FROM`/`TO` bounds as values of the period's element type, or cast them explicitly. Match the bound literals to the type of the range or period the `FOR PORTION OF` clause targets.

## Example

*Illustrative* — an incompatible bound type.

```text
ERROR:  could not coerce FOR PORTION OF start bound from text to date
```

## Related

- [could not coerce expression to the RETURNING type](./could-not-coerce-expression-to-the-returning-type.md)
- [cannot cast behavior expression of type to](./cannot-cast-behavior-expression-of-type-to.md)
