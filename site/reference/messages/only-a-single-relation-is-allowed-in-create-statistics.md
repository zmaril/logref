---
message: "only a single relation is allowed in CREATE STATISTICS"
slug: only-a-single-relation-is-allowed-in-create-statistics
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:106"
  - "postgres/src/backend/commands/statscmds.c:115"
reproduced: false
---

# `only a single relation is allowed in CREATE STATISTICS`

## What it means

A `CREATE STATISTICS` command referenced more than one table. Extended statistics objects are defined over the columns of a single relation.

## When it happens

It arises from `CREATE STATISTICS ... ON ... FROM t1, t2` or a similar form that names multiple relations, which is not supported.

## How to fix

Define the statistics over one table only. If you need cross-table correlation, that is not something extended statistics model; create separate statistics per table and rely on the planner's join estimation.

## Example

*Illustrative* — statistics over two relations.

```sql
CREATE STATISTICS s ON a, b FROM t1, t2;  -- only one relation allowed
```

## Related

- [only one FOR ORDINALITY column is allowed](./only-one-for-ordinality-column-is-allowed.md)
- [invalid empty fraction statistic](./invalid-empty-fraction-statistic.md)
