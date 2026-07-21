---
message: "edge pattern must be preceded by a vertex pattern"
slug: edge-pattern-must-be-preceded-by-a-vertex-pattern
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_graphtable.c:292"
reproduced: false
---

# `edge pattern must be preceded by a vertex pattern`

## What it means

A graph-table pattern in a `GRAPH_TABLE` query started an edge without a preceding vertex. Graph patterns alternate vertices and edges, so an edge must follow a vertex pattern.

## When it happens

It fires while parsing a `GRAPH_TABLE ... MATCH` pattern where an edge pattern appears first or two edges appear in a row.

## How to fix

Write the pattern as an alternating sequence beginning and ending with a vertex, for example `(a)-[e]->(b)`. Insert the missing vertex pattern before the edge.

## Example

*Illustrative* — an edge with no leading vertex.

```text
ERROR:  edge pattern must be preceded by a vertex pattern
```

## Related

- [element pattern quantifier is not supported](./element-pattern-quantifier-is-not-supported.md)
- [destination vertex of edge does not exist](./destination-vertex-of-edge-does-not-exist.md)
