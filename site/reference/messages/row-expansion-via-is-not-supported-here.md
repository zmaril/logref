---
message: "row expansion via \"*\" is not supported here"
slug: row-expansion-via-is-not-supported-here
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:460"
  - "postgres/src/backend/parser/parse_target.c:738"
reproduced: false
---

# `row expansion via "*" is not supported here`

## What it means

A `*` row expansion (as in `tablename.*` or `rowvar.*`) was used in a context that does not accept expanding a row into its individual columns. The placeholder in the message is the `*` notation. Some contexts require a single value, not an expanded column list.

## When it happens

It arises when writing `something.*` where only a scalar or a single composite is allowed — for example inside certain expressions, function arguments, or clauses that cannot take a variable-width column list.

## How to fix

List the needed columns explicitly instead of `*`, or pass the whole row as a single composite value (without `.*`) where a composite is acceptable. Restructure the expression so a single value is provided where one is required.

## Example

*Illustrative* — using row expansion where it is not allowed.

```text
ERROR:  row expansion via "*" is not supported here
```

## Related

- [subquery must return only one column](./subquery-must-return-only-one-column.md)
- [SELECT ... INTO is not allowed here](./select-into-is-not-allowed-here.md)
