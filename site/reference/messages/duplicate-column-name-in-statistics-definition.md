---
message: "duplicate column name in statistics definition"
slug: duplicate-column-name-in-statistics-definition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:486"
reproduced: false
---

# `duplicate column name in statistics definition`

## What it means

A `CREATE STATISTICS` command listed the same column twice. The extended-statistics object must reference each column at most once.

## When it happens

It fires from `CREATE STATISTICS` when the column list repeats a column name.

## How to fix

List each column once in the `CREATE STATISTICS` column list. Remove the duplicate.

## Example

*Illustrative* — a repeated column in a statistics definition.

```sql
CREATE STATISTICS s (dependencies) ON a, a FROM t;
-- duplicate column name in statistics definition
```

## Related

- [duplicate expression in statistics definition](./duplicate-expression-in-statistics-definition.md)
- [duplicate column in publication column list](./duplicate-column-in-publication-column-list.md)
