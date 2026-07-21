---
message: "destination vertex \"%s\" of edge \"%s\" does not exist"
slug: destination-vertex-of-edge-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:219"
reproduced: false
---

# `destination vertex "%s" of edge "%s" does not exist`

## What it means

A `CREATE PROPERTY GRAPH` (or an alter of one) defined an edge whose destination vertex table is not among the graph's declared vertices. The placeholders are the destination and edge names.

## When it happens

It fires while defining a property graph when an edge's `DESTINATION` references a vertex element that was not declared in the `VERTEX TABLES` list.

## How to fix

Declare the destination vertex table in the graph's `VERTEX TABLES` before referencing it from an edge, and make sure the name matches exactly. Every edge must connect two vertices that the graph knows about.

## Example

*Illustrative* — an edge pointing at an undeclared vertex.

```text
ERROR:  destination vertex "accounts" of edge "owns" does not exist
```

## Related

- [element of property graph is not a vertex](./element-of-property-graph-is-not-a-vertex.md)
- [edge pattern must be preceded by a vertex pattern](./edge-pattern-must-be-preceded-by-a-vertex-pattern.md)
