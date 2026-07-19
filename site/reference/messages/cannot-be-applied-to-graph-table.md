---
message: "%s cannot be applied to GRAPH_TABLE"
slug: cannot-be-applied-to-graph-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:4006"
reproduced: false
---

# `%s cannot be applied to GRAPH_TABLE`

## What it means

A locking clause such as `FOR UPDATE` was applied to a `GRAPH_TABLE` result. The graph-table construct produces a computed result set from a property-graph query, which is not a lockable base table.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` names a `GRAPH_TABLE` item among its locked relations.

## How to fix

Remove the locking clause from the `GRAPH_TABLE` reference. Lock the underlying base tables directly if you need row locks on stored data.

## Example

*Illustrative* — locking a graph-table result.

```text
ERROR:  FOR UPDATE cannot be applied to GRAPH_TABLE
```

## Related

- [cannot be applied to a table function](./cannot-be-applied-to-a-table-function.md)
- [cannot be applied to a with query](./cannot-be-applied-to-a-with-query.md)
