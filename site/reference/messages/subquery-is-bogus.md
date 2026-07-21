---
message: "subquery is bogus"
slug: subquery-is-bogus
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/prep/prepjointree.c:1962"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:2369"
reproduced: false
---

# `subquery is bogus`

## What it means

Internal planner/rewriter error. A subquery reached a code path in an unexpected or malformed state — its structure did not match what the processing step assumed. It is a self-consistency check, not an ordinary subquery error.

## When it happens

It fires from query-tree processing when a sub-select node is not shaped as expected. Ordinary subqueries with real problems produce specific messages; this indicates an internal inconsistency.

## How to fix

This is an internal consistency guard. If a real query triggers it, capture the statement and any views/rules/extensions involved and report it as a reproducible bug.

## Example

*Illustrative* — the planner rejecting a malformed subquery node.

```text
ERROR:  subquery is bogus
```

## Related

- [subquery must return only one column](./subquery-must-return-only-one-column.md)
- [ORDER/GROUP BY expression not found in targetlist](./order-group-by-expression-not-found-in-targetlist.md)
