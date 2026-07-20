---
message: "common column name \"%s\" appears more than once in right table"
slug: common-column-name-appears-more-than-once-in-right-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_AMBIGUOUS_COLUMN
    code: "42702"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:1514"
reproduced: false
---

# `common column name "%s" appears more than once in right table`

## What it means

A natural or `USING` join found a shared column name that occurs more than once in the right table, so the join column is ambiguous on the right side.

## When it happens

It happens with `NATURAL JOIN` or `JOIN ... USING` when the right table exposes the same column name more than once.

## How to fix

Make the shared column name unique on the right side, using explicit `ON` conditions or aliased subqueries to remove the duplicate name.

## Example

*Illustrative* — a duplicated common column on the right.

```text
ERROR:  common column name "id" appears more than once in right table
```

## Related

- [common column name appears more than once in left table](./common-column-name-appears-more-than-once-in-left-table.md)
- [column name appears more than once in USING clause](./column-name-appears-more-than-once-in-using-clause.md)
