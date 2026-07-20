---
message: "property graph \"%s\" element \"%s\" has no label \"%s\""
slug: property-graph-element-has-no-label
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1519"
  - "postgres/src/backend/commands/propgraphcmds.c:1555"
  - "postgres/src/backend/commands/propgraphcmds.c:1605"
  - "postgres/src/backend/commands/propgraphcmds.c:1643"
reproduced: false
---

# `property graph "%s" element "%s" has no label "%s"`

## What it means

A property-graph definition referenced a label on one of its vertex or edge elements that the element does not have. The placeholders name the graph, the element, and the missing label. Graph queries address elements by label, so a label that is not attached to the element cannot be resolved.

## When it happens

Writing or altering a property graph, or a graph query, that names a label for an element which was never declared with that label.

## How to fix

Use a label the element actually carries, or add the label to the element's definition. List the element's declared labels in the `CREATE PROPERTY GRAPH` definition and match the spelling and case exactly.

## Example

*Illustrative* — a graph element queried by an undeclared label.

```text
ERROR:  property graph "g" element "e" has no label "L"
```

## Related

- [an edge cannot connect more than two vertices even in a cyclic pattern](./an-edge-cannot-connect-more-than-two-vertices-even-in-a-cyclic-pattern.md)
- [column named in key does not exist](./column-named-in-key-does-not-exist.md)
