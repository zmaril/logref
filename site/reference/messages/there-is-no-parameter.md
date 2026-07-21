---
message: "there is no parameter $%d"
slug: there-is-no-parameter
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_PARAMETER
    code: "42P02"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:915"
  - "postgres/src/backend/parser/parse_param.c:109"
  - "postgres/src/backend/parser/parse_param.c:141"
  - "postgres/src/backend/parser/parse_param.c:203"
  - "postgres/src/backend/parser/parse_param.c:302"
reproduced: false
---

# `there is no parameter $%d`

## What it means

A query referenced a positional parameter `$n` for which no value was supplied. The placeholder is the parameter number. Parameter numbers must fall within the set of parameters the statement was prepared or bound with.

## When it happens

Using `$n` in a prepared statement, `PREPARE`, or a parameterized query where `n` exceeds the number of parameters provided, or referencing a parameter number in a context (like a plain interactive query) that has none.

## How to fix

Use only parameter numbers that were declared or bound, numbered from `$1`. Supply the missing parameter, or renumber the reference. In `PREPARE`, declare all parameter types; in client code, ensure the number of bound values matches the highest `$n` used.

## Example

*Illustrative* — a parameter that was never bound.

```sql
PREPARE s (int) AS SELECT $1, $2;
```

## Related

- [type of parameter does not match that when preparing the plan](./type-of-parameter-does-not-match-that-when-preparing-the-plan.md)
- [step size cannot equal zero](./step-size-cannot-equal-zero.md)
