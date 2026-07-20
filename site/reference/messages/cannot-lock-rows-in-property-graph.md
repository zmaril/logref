---
message: "cannot lock rows in property graph \"%s\""
slug: cannot-lock-rows-in-property-graph
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1276"
reproduced: false
---

# `cannot lock rows in property graph "%s"`

## What it means

A row-locking clause was applied to a query over a property graph object. A property graph is a logical view over its backing tables, not a set of directly lockable rows, so row locking does not apply. The placeholder is the property graph name.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` reads from a property graph.

## How to fix

Remove the row-locking clause from queries over the property graph, or lock the underlying vertex and edge tables directly if you need row-level locking.

## Example

*Illustrative* — FOR UPDATE on a property graph.

```text
ERROR:  cannot lock rows in property graph "social_graph"
```

## Related

- [cannot lock rows in view](./cannot-lock-rows-in-view.md)
- [cannot lock rows in materialized view](./cannot-lock-rows-in-materialized-view.md)
