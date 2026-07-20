---
message: "expression contains variables"
slug: expression-contains-variables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:3117"
reproduced: false
---

# `expression contains variables`

## What it means

A context that requires a constant, variable-free expression was given one that references table columns. The placeholder-free message names the general problem: a `Var` (column reference) appeared where only a fixed expression is allowed.

## When it happens

It fires from features that must evaluate an expression without any row context — for example a partition-bound expression, certain index or default definitions, or code that deparses a standalone expression — when the expression refers to a column.

## How to fix

Rewrite the expression so it does not reference table columns. Use literals, immutable function calls, or parameters instead. If you intended to reference a column, you are using it in a place that does not allow row context; move the logic to where the column is available (for example a computed column, a view, or a trigger).

## Example

*Illustrative* — a bound must be constant, not column-based.

```sql
... FOR VALUES IN (some_column);  -- invalid: references a column
```

## Related

- [expression contains variables of more than one relation](./expression-contains-variables-of-more-than-one-relation.md)
- [expression returning multiple columns is not valid in parameter list](./expression-returning-multiple-columns-is-not-valid-in-parameter-list.md)
