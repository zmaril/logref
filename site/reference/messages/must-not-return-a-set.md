---
message: "%s must not return a set"
slug: must-not-return-a-set
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:1121"
  - "postgres/src/backend/parser/parse_expr.c:3121"
reproduced: false
---

# `%s must not return a set`

## What it means

A function used in a context that requires a single value returns a set instead. The placeholder names the role the function plays (for example a support or transition function). Set-returning functions are not allowed there.

## When it happens

It arises when a set-returning function is supplied where a scalar-returning one is required — for example as an aggregate's transition/final function, an operator's implementing function, or an index support function.

## How to fix

Supply a function that returns a single value in that position. If your logic needs multiple values, restructure so the set-returning function is called in a normal `FROM`/`SELECT` context, and give the support role a scalar function.

## Example

*Illustrative* — a set-returning function as an operator implementation.

```text
ERROR:  operator procedure must not return a set
```

## Related

- [must be used to call a parameterless aggregate function](./must-be-used-to-call-a-parameterless-aggregate-function.md)
- [must not omit initial value when transition function is strict and transition](./must-not-omit-initial-value-when-transition-function-is-strict-and-transition.md)
