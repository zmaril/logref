---
message: "unrecognized node type in jointree: %d"
slug: unrecognized-node-type-in-jointree
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:5443"
  - "postgres/src/backend/utils/adt/ruleutils.c:5450"
reproduced: false
---

# `unrecognized node type in jointree: %d`

## What it means

Internal error. Planner code walking a query's join tree met a node kind that is not one of the from-item/join/range-table kinds it expects there.

## When it happens

It fires when the join tree contains an unexpected node — a sign of an inconsistently built query tree, not of ordinary SQL.

## How to fix

This is an internal consistency guard. If a real query reaches it, capture the query and report it as a reproducible planner bug.

## Example

*Illustrative* — an unexpected join-tree node.

```text
ERROR:  unrecognized node type in jointree: 704
```

## Related

- [unexpected rtekind: %d](./unexpected-rtekind.md)
- [unrecognized A_Expr kind: %d](./unrecognized-a-expr-kind-1a210a.md)
