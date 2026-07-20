---
message: "cannot define statistics for relation \"%s\""
slug: cannot-define-statistics-for-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:133"
reproduced: false
---

# `cannot define statistics for relation "%s"`

## What it means

A `CREATE STATISTICS` targeted a relation kind that cannot hold extended statistics — for example a view or another relation without collectable table data. The placeholder is the relation name.

## When it happens

It occurs when a statistics object is defined on a relation that is not an ordinary table or materialized view.

## How to fix

Create statistics only on tables and materialized views that carry data. Point the `CREATE STATISTICS` at the base relation whose column correlations you want to capture.

## Example

*Illustrative* — statistics on an unsupported relation.

```text
ERROR:  cannot define statistics for relation "v"
```

## Related

- [cannot create multivariate statistics on this expression](./cannot-create-multivariate-statistics-on-this-expression.md)
- [cannot create extended statistics on a single non-virtual column](./cannot-create-extended-statistics-on-a-single-non-virtual-column.md)
