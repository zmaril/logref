---
message: "functions in FROM can return at most %d columns"
slug: functions-in-from-can-return-at-most-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_COLUMNS
    code: "54011"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:2018"
  - "postgres/src/backend/parser/parse_relation.c:2103"
reproduced: false
---

# `functions in FROM can return at most %d columns`

## What it means

A set-returning function used in `FROM` was declared to return more columns than allowed. The `%d` is the maximum. A function's result column count is capped like a table's.

## When it happens

Defining or calling a table function whose column definition list or `RETURNS TABLE`/record shape exceeds the column limit (commonly 1600).

## How to fix

Reduce the number of returned columns below the limit. Combine columns or return fewer, narrower results.

## Example

*Illustrative* — too many result columns.

```text
ERROR:  functions in FROM can return at most 1600 columns
```

## Related

- [function has wrong number of declared columns](./function-has-wrong-number-of-declared-columns.md)
- [functions cannot have more than argument](./functions-cannot-have-more-than-argument.md)
