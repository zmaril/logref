---
message: "column \"%s\" of relation \"%s\" appears more than once"
slug: column-of-relation-appears-more-than-once
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/commands/analyze.c:1064"
reproduced: false
---

# `column "%s" of relation "%s" appears more than once`

## What it means

A column list named the same column of a relation more than once where duplicates are not allowed, for example in an `ANALYZE` column list. Each column may appear only once.

## When it happens

It happens in commands such as `ANALYZE tab (col, col)` or similar per-column lists when a column is repeated.

## How to fix

List each column only once. Remove the duplicate reference from the column list.

## Example

*Illustrative* — a repeated column in ANALYZE.

```sql
ANALYZE t (a, a);
-- ERROR:  column "a" of relation "t" appears more than once
```

## Related

- [column name is not unique](./column-name-is-not-unique.md)
- [column name specified more than once](./column-name-specified-more-than-once.md)
