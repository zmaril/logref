---
message: "element label %u not found"
slug: element-label-not-found
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1215"
reproduced: false
---

# `element label %u not found`

## What it means

An internal property-graph guard. Code looked up a graph element label by its internal identifier and found none. The placeholder is the label id. This is a "can't happen" catalog-consistency check.

## When it happens

It fires while processing a property-graph query when an expected label identifier is missing, which points at a catalog inconsistency rather than user action.

## How to fix

This is not a routine user error. If it reproduces, capture the property-graph definition and the query and report it to the PostgreSQL developers. Verifying the graph's element and label catalog entries may reveal damage.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  element label 42 not found
```

## Related

- [element of property graph is not a vertex](./element-of-property-graph-is-not-a-vertex.md)
- [element of property graph is not an edge](./element-of-property-graph-is-not-an-edge.md)
