---
message: "argument name \"%s\" used more than once"
slug: argument-name-used-more-than-once
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:196"
reproduced: false
---

# `argument name "%s" used more than once`

## What it means

A function or routine definition listed the same parameter name twice, but parameter names must be unique within a signature.

## When it happens

It occurs in `CREATE FUNCTION`/`CREATE PROCEDURE` (or a `DO` block's declarations) when two parameters share a name.

## How to fix

Rename the duplicated parameter so each name is unique. Distinct names are required so arguments can be referenced unambiguously by name inside the body and in named-argument calls.

## Example

*Illustrative* — a repeated parameter name.

```sql
CREATE FUNCTION f(x int, x int) ...;  -- ERROR:  argument name "x" used more than once
```

## Related

- [argument of must be a name](./argument-of-must-be-a-name.md)
- [aggregates cannot use named arguments](./aggregates-cannot-use-named-arguments.md)
