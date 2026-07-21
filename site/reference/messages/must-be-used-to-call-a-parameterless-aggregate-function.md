---
message: "%s(*) must be used to call a parameterless aggregate function"
slug: must-be-used-to-call-a-parameterless-aggregate-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:809"
  - "postgres/src/backend/parser/parse_func.c:875"
reproduced: false
---

# `%s(*) must be used to call a parameterless aggregate function`

## What it means

An aggregate that takes no arguments was called without the required `(*)` form. The placeholder shows the aggregate; it must be invoked as `agg(*)`.

## When it happens

It arises when calling a parameterless aggregate like `count` in its no-argument form without the star — writing `count()` instead of `count(*)`.

## How to fix

Call the aggregate with `(*)`, for example `count(*)`. The star form is how a parameterless aggregate is invoked over all rows.

## Example

*Illustrative* — a parameterless aggregate without the star.

```sql
SELECT count() FROM t;  -- use count(*)
```

## Related

- [must not return a set](./must-not-return-a-set.md)
- [must not omit initial value when transition function is strict and transition](./must-not-omit-initial-value-when-transition-function-is-strict-and-transition.md)
