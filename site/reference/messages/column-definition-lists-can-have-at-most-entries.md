---
message: "column definition lists can have at most %d entries"
slug: column-definition-lists-can-have-at-most-entries
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_COLUMNS
    code: "54011"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:1930"
reproduced: false
---

# `column definition lists can have at most %d entries`

## What it means

A column definition list, such as the one used with a record-returning function, named more columns than the server allows. The list cannot exceed the maximum column count, so it is rejected.

## When it happens

It occurs when a `ROWS FROM` or function call supplies a column definition list with more entries than the compiled limit, which is 1600 by default.

## How to fix

Reduce the number of columns in the definition list to the limit or fewer. Split the result into narrower structures if you genuinely need more columns.

## Example

*Illustrative* — too many column definitions.

```text
ERROR:  column definition lists can have at most 1600 entries
```

## Related

- [cannot use more than columns in an index](./cannot-use-more-than-columns-in-an-index.md)
- [character number must be positive](./character-number-must-be-positive.md)
