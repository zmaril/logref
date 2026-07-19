---
message: "functions cannot have more than %d argument"
slug: functions-cannot-have-more-than-argument
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_ARGUMENTS
    code: "54023"
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:158"
  - "postgres/src/backend/parser/parse_func.c:2364"
reproduced: false
---

# `functions cannot have more than %d argument`

## What it means

A function definition declared more arguments than Postgres allows. The `%d` is the maximum. A single function's argument count is capped.

## When it happens

Creating a function with an argument list longer than the server's limit (commonly 100), often from generated DDL.

## How to fix

Reduce the number of arguments below the limit — pass grouped values as a composite type or array instead of many separate parameters.

## Example

*Illustrative* — too many function arguments.

```text
ERROR:  functions cannot have more than 100 argument
```

## Related

- [functions in FROM can return at most columns](./functions-in-from-can-return-at-most-columns.md)
- [function name is not unique](./function-name-is-not-unique.md)
