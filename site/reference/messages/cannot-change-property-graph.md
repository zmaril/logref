---
message: "cannot change property graph \"%s\""
slug: cannot-change-property-graph
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1187"
reproduced: false
---

# `cannot change property graph "%s"`

## What it means

A data-modifying or unsupported alter statement targeted a property graph object in a way it does not allow. A property graph is defined over underlying tables and cannot be changed through the attempted operation. The placeholder is the object name.

## When it happens

It occurs when a command tries to modify a `PROPERTY GRAPH` object outside the operations it supports.

## How to fix

Modify the underlying tables that the property graph is built on, or drop and recreate the property graph definition. The graph object itself is not directly writable through this path.

## Example

*Illustrative* — altering a property graph.

```text
ERROR:  cannot change property graph "g"
```

## Related

- [cannot change materialized view](./cannot-change-materialized-view.md)
- [cannot be applied to graph table](./cannot-be-applied-to-graph-table.md)
