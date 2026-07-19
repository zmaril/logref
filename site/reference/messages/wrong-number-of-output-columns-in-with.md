---
message: "wrong number of output columns in WITH"
slug: wrong-number-of-output-columns-in-with
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_cte.c:379"
  - "postgres/src/backend/parser/parse_cte.c:407"
reproduced: false
---

# `wrong number of output columns in WITH`

## What it means

A `WITH` query's column-name list does not match the number of columns the query actually produces.

## When it happens

It arises when a CTE is written as `WITH cte(col1, col2) AS (SELECT ...)` and the parenthesized alias list names a different number of columns than the `SELECT` returns.

## How to fix

Make the column-alias list after the CTE name have exactly as many entries as the CTE's query outputs. Add or remove alias names, or drop the list to inherit the query's own column names.

## Example

*Illustrative* — a CTE alias-list length mismatch.

```text
ERROR:  wrong number of output columns in WITH
```

## Related

- [VALUES lists must all be the same length](./values-lists-must-all-be-the-same-length.md)
- [wrong number of tlist entries](./wrong-number-of-tlist-entries.md)
