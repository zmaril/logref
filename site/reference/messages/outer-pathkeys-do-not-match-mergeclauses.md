---
message: "outer pathkeys do not match mergeclauses"
slug: outer-pathkeys-do-not-match-mergeclauses
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/createplan.c:4600"
  - "postgres/src/backend/optimizer/plan/createplan.c:4605"
reproduced: false
---

# `outer pathkeys do not match mergeclauses`

## What it means

Internal planner error. When setting up a merge join, the sort ordering (pathkeys) established for the outer input did not line up with the merge clauses that drive the join. The two must agree for a merge join to be valid.

## When it happens

It fires while the planner is finalizing a merge-join path. Ordinary queries do not raise it; it indicates the planner reached an inconsistent state constructing that path.

## How to fix

This is an internal consistency guard. If a real query triggers it, capture the statement and the involved indexes/sort keys and report it as a reproducible planner bug.

## Example

*Illustrative* — a merge join whose outer sort keys disagree with its clauses.

```text
ERROR:  outer pathkeys do not match mergeclauses
```

## Related

- [ORDER/GROUP BY expression not found in targetlist](./order-group-by-expression-not-found-in-targetlist.md)
- [result nodes do not support mark/restore](./result-nodes-do-not-support-mark-restore.md)
