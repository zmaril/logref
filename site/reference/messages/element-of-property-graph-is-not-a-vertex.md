---
message: "element \"%s\" of property graph \"%s\" is not a vertex"
slug: element-of-property-graph-is-not-a-vertex
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1736"
reproduced: false
---

# `element "%s" of property graph "%s" is not a vertex`

## What it means

A property-graph definition or query referenced an element as a vertex, but that element is defined as an edge. The placeholders are the element and graph names. Vertex and edge roles are distinct.

## When it happens

It fires while defining or querying a property graph when an edge element is used where a vertex is required.

## How to fix

Reference a declared vertex element where a vertex is expected. Check the graph's `VERTEX TABLES`/`EDGE TABLES` declarations and use the right element name for the role.

## Example

*Illustrative* — using an edge where a vertex is required.

```text
ERROR:  element "owns" of property graph "g" is not a vertex
```

## Related

- [element of property graph is not an edge](./element-of-property-graph-is-not-an-edge.md)
- [destination vertex of edge does not exist](./destination-vertex-of-edge-does-not-exist.md)
