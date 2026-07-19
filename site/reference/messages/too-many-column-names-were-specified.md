---
message: "too many column names were specified"
slug: too-many-column-names-were-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/createas.c:210"
  - "postgres/src/backend/commands/createas.c:521"
reproduced: false
---

# `too many column names were specified`

## What it means

A column alias list named more columns than the underlying relation or subquery produces. The number of provided names exceeds the number of available columns.

## When it happens

It arises when aliasing a table function, subquery, or `VALUES` list with more column names than it has columns — for example `... AS t(a, b, c)` over something that yields two columns.

## How to fix

Provide exactly as many column names as the source has columns, or fewer. Count the output columns of the subquery/function and match the alias list to them.

## Example

*Illustrative* — an alias list longer than the column count.

```text
ERROR:  too many column names were specified
```

## Related

- [table name "%s" specified more than once](./table-name-specified-more-than-once.md)
- [subquery must return only one column](./subquery-must-return-only-one-column.md)
