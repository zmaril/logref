---
message: "Aggref found in non-Agg plan node"
slug: aggref-found-in-non-agg-plan-node
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execExpr.c:1096"
reproduced: false
---

# `Aggref found in non-Agg plan node`

## What it means

The executor found an aggregate reference (`Aggref`) inside a plan node that is not an aggregation node, which should never happen in a correctly built plan — an internal consistency guard.

## When it happens

It is raised during execution if a plan tree places an aggregate expression somewhere the planner should have routed through an Agg node, typically a planner bug or a malformed plan from an extension.

## How to fix

This is an internal error rather than a query you can rewrite. If it recurs, capture the query and `EXPLAIN` output plus any custom planner extensions and report it. There is no user-level workaround.

## Example

*Illustrative* — an aggregate reference in a non-aggregate node.

```text
ERROR:  Aggref found in non-Agg plan node
```

## Related

- [Aggref found where not expected](./aggref-found-where-not-expected.md)
- [append child's targetlist doesn't match Append](./append-child-s-targetlist-doesn-t-match-append.md)
