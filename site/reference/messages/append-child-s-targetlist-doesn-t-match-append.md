---
message: "Append child's targetlist doesn't match Append"
slug: append-child-s-targetlist-doesn-t-match-append
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/createplan.c:1347"
reproduced: false
---

# `Append child's targetlist doesn't match Append`

## What it means

The executor found that a child plan under an Append node produces a column list that does not line up with the Append's own output columns, which a correct plan should never do — an internal consistency guard.

## When it happens

It is raised during execution of an Append (used for `UNION ALL`, inheritance, and partitioned scans) if a child's target list is inconsistent with the parent's, generally through a planner bug or a custom scan provider.

## How to fix

This is an internal error rather than a query you can rewrite with confidence. If it recurs, capture the query, `EXPLAIN` output, and any custom scan or planner extensions and report it. There is no reliable user-level workaround.

## Example

*Illustrative* — a mismatched Append child target list.

```text
ERROR:  Append child's targetlist doesn't match Append
```

## Related

- [Aggref found in non-Agg plan node](./aggref-found-in-non-agg-plan-node.md)
- [already-planned subqueries not supported](./already-planned-subqueries-not-supported.md)
