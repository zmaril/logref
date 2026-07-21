---
message: "duplicate expression in statistics definition"
slug: duplicate-expression-in-statistics-definition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:521"
reproduced: false
---

# `duplicate expression in statistics definition`

## What it means

A `CREATE STATISTICS` command listed the same expression twice. Each expression in an extended-statistics object must be distinct.

## When it happens

It fires from `CREATE STATISTICS` when two entries in the expression list are identical.

## How to fix

List each expression once. Remove the duplicate from the `CREATE STATISTICS` definition.

## Example

*Illustrative* — a repeated expression in a statistics definition.

```sql
CREATE STATISTICS s ON (a + b), (a + b) FROM t;
-- duplicate expression in statistics definition
```

## Related

- [duplicate column name in statistics definition](./duplicate-column-name-in-statistics-definition.md)
- [duplicate column in publication column list](./duplicate-column-in-publication-column-list.md)
