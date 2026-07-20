---
message: "too many function arguments"
slug: too-many-function-arguments
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/clauses.c:5037"
  - "postgres/src/backend/optimizer/util/clauses.c:5163"
reproduced: false
---

# `too many function arguments`

## What it means

A function was defined or called with more arguments than Postgres permits. Functions have a fixed maximum number of arguments, and this exceeds it.

## When it happens

It arises from `CREATE FUNCTION` with too many parameters, or a call site that supplies more arguments than the maximum the system supports.

## How to fix

Reduce the number of arguments below the maximum. For functions that need many inputs, pass a composite type, an array, or a record instead of a long argument list.

## Example

*Illustrative* — a function with too many parameters.

```text
ERROR:  too many function arguments
```

## Related

- [too many arguments](./too-many-arguments.md)
- [proargnames is not a 1-D text array of length %d or it contains nulls](./proargnames-is-not-a-1-d-text-array-of-length-or-it-contains-nulls.md)
