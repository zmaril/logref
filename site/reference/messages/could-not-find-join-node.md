---
message: "could not find join node %d"
slug: could-not-find-join-node
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/prep/prepjointree.c:4601"
reproduced: false
---

# `could not find join node %d`

## What it means

The planner could not locate a join node by its identifier while transforming the join tree. The `%d` is the node ID. This is an internal invariant of join-tree processing.

## When it happens

It fires during join-tree flattening or pull-up when an expected join node is missing. Reaching it points at an internal planner problem rather than anything in the query.

## How to fix

This is an internal error. If a specific query triggers it, note the exact statement (especially complex or deeply nested joins) and report a reproducible case.

## Example

*Illustrative* — a missing join node during planning.

```text
ERROR:  could not find join node 5
```

## Related

- [could not find JoinExpr for whole-row reference](./could-not-find-joinexpr-for-whole-row-reference.md)
- [could not find inherited attribute of relation](./could-not-find-inherited-attribute-of-relation.md)
