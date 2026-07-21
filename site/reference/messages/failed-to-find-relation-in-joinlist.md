---
message: "failed to find relation %d in joinlist"
slug: failed-to-find-relation-in-joinlist
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/analyzejoins.c:127"
  - "postgres/src/backend/optimizer/plan/analyzejoins.c:2663"
reproduced: false
---

# `failed to find relation %d in joinlist`

## What it means

Internal planner error. A relation the planner was manipulating could not be found in the query's join list where it was expected. The `%d` is the relation index. It is a planner-invariant guard.

## When it happens

It fires during join processing (for example join removal or reordering) when the join-list bookkeeping became inconsistent. Ordinary queries do not surface it; it indicates a planner bug.

## How to fix

This is a can't-happen guard. Capture the query and report it as a planner bug with a reproducible case.

## Example

*Illustrative* — a relation missing from the join list.

```text
ERROR:  failed to find relation 3 in joinlist
```

## Related

- [failed to build any-way joins](./failed-to-build-any-way-joins.md)
- [failed to apply nullingrels to a non-Var](./failed-to-apply-nullingrels-to-a-non-var.md)
