---
message: "an edge cannot connect more than two vertices even in a cyclic pattern"
slug: an-edge-cannot-connect-more-than-two-vertices-even-in-a-cyclic-pattern
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:290"
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:299"
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:314"
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:323"
reproduced: false
---

# `an edge cannot connect more than two vertices even in a cyclic pattern`

## What it means

A property-graph query defined an edge pattern that ties together more than two vertices. An edge connects exactly two endpoints (which may coincide in a cycle); a pattern implying more is invalid. This comes from property-graph query rewriting.

## When it happens

Writing a graph pattern in a property-graph query where an edge element is shared among more than two vertex elements, producing an over-connected edge.

## How to fix

Restructure the pattern so each edge connects exactly two vertices. Use additional edges to express multi-way relationships. Review the graph pattern's vertex/edge chaining so no single edge spans more than two endpoints.

## Example

*Illustrative* — an over-connected edge pattern.

```text
ERROR:  an edge cannot connect more than two vertices even in a cyclic pattern
```

## Related

- [is not a property graph](./is-not-a-property-graph.md)
- [conditional UNION/INTERSECT/EXCEPT statements are not implemented](./conditional-union-intersect-except-statements-are-not-implemented.md)
