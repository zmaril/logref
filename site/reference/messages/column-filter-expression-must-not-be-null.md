---
message: "column filter expression must not be null"
slug: column-filter-expression-must-not-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/executor/nodeTableFuncscan.c:415"
reproduced: false
---

# `column filter expression must not be null`

## What it means

A function that takes a column filter expression received `NULL` for it. The filter argument must be a concrete expression, so a null value is rejected.

## When it happens

It occurs in a function or command that accepts a column filter, such as some diagnostic or extension routines, when the filter argument is passed as `NULL`.

## How to fix

Supply a real filter expression rather than `NULL`. Provide the expression the function expects, or omit the argument if the function allows a default.

## Example

*Illustrative* — a null column filter.

```text
ERROR:  column filter expression must not be null
```

## Related

- [check_toast cannot be null](./check-toast-cannot-be-null.md)
- [case not found](./case-not-found.md)
