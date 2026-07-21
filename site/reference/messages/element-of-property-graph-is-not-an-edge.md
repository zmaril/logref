---
message: "element \"%s\" of property graph \"%s\" is not an edge"
slug: element-of-property-graph-is-not-an-edge
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1768"
reproduced: false
---

# `element "%s" of property graph "%s" is not an edge`

## What it means

A property-graph definition or query referenced an element as an edge, but that element is defined as a vertex. The placeholders are the element and graph names. Vertex and edge roles are distinct.

## When it happens

It fires while defining or querying a property graph when a vertex element is used where an edge is required.

## How to fix

Reference a declared edge element where an edge is expected. Check the graph's `EDGE TABLES` declarations and use the right element name for the role.

## Example

*Illustrative* — using a vertex where an edge is required.

```text
ERROR:  element "accounts" of property graph "g" is not an edge
```

## Related

- [element of property graph is not a vertex](./element-of-property-graph-is-not-a-vertex.md)
- [edge pattern must be preceded by a vertex pattern](./edge-pattern-must-be-preceded-by-a-vertex-pattern.md)
