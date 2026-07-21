---
message: "common column name \"%s\" appears more than once in left table"
slug: common-column-name-appears-more-than-once-in-left-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_AMBIGUOUS_COLUMN
    code: "42702"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:1490"
reproduced: false
---

# `common column name "%s" appears more than once in left table`

## What it means

A natural join (or `USING` join) found a shared column name that occurs more than once in the left table, so it cannot decide which column to join on. The shared name is ambiguous on the left side.

## When it happens

It happens with `NATURAL JOIN` or `JOIN ... USING` when the left table exposes the same column name twice (for example after a prior join produced duplicate names).

## How to fix

Disambiguate the left side so the shared column name is unique, for example by using explicit `ON` conditions or by renaming columns with aliases in a subquery.

## Example

*Illustrative* — a duplicated common column on the left.

```text
ERROR:  common column name "id" appears more than once in left table
```

## Related

- [common column name appears more than once in right table](./common-column-name-appears-more-than-once-in-right-table.md)
- [column name appears more than once in USING clause](./column-name-appears-more-than-once-in-using-clause.md)
