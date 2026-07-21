---
message: "could not coerce %s expression (%s) to the RETURNING type"
slug: could-not-coerce-expression-to-the-returning-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:5279"
  - "postgres/src/backend/executor/execExprInterp.c:5287"
reproduced: false
---

# `could not coerce %s expression (%s) to the RETURNING type`

## What it means

A value produced by a `RETURNING` (or `MERGE ... RETURNING`) expression could not be coerced to the declared return type. The placeholders describe the expression and the target type. No valid cast exists between the produced value and the expected type.

## When it happens

A `RETURNING` clause whose expression yields a type incompatible with the column or result type it must match — often after a type change or a mismatched cast in the returning list.

## How to fix

Add an explicit cast to the `RETURNING` expression, or adjust it to produce the expected type. Make sure the returned value's type matches what the statement's result columns require.

## Example

*Illustrative* — an uncastable RETURNING expression.

```text
ERROR:  could not coerce OLD expression (x) to the RETURNING type
```

## Related

- [cannot use type in RETURNING clause of](./cannot-use-type-in-returning-clause-of.md)
- [could not coerce FOR PORTION OF bound from to](./could-not-coerce-for-portion-of-bound-from-to.md)
