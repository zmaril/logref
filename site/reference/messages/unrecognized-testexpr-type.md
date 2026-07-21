---
message: "unrecognized testexpr type: %d"
slug: unrecognized-testexpr-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeSubplan.c:969"
  - "postgres/src/backend/utils/adt/ruleutils.c:12524"
reproduced: false
---

# `unrecognized testexpr type: %d`

## What it means

Internal error. Planner code handling a sub-link test expression (the comparison built for `IN`/`ANY`/`ALL` subqueries) met a node type it does not expect.

## When it happens

It fires while processing a sub-link's test expression when the node is outside the known set. A valid subquery comparison does not produce it.

## How to fix

This is an internal consistency guard. If a real subquery triggers it, capture the query and report it as a reproducible planner bug.

## Example

*Illustrative* — an unrecognized sublink test expression.

```text
ERROR:  unrecognized testexpr type: 704
```

## Related

- [unrecognized A_Expr kind: %d](./unrecognized-a-expr-kind-1a210a.md)
- [unrecognized node type in jointree: %d](./unrecognized-node-type-in-jointree.md)
