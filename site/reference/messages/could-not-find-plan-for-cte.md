---
message: "could not find plan for CTE \"%s\""
slug: could-not-find-plan-for-cte
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/allpaths.c:3105"
  - "postgres/src/backend/optimizer/plan/createplan.c:3783"
  - "postgres/src/backend/optimizer/plan/createplan.c:3794"
  - "postgres/src/backend/utils/adt/selfuncs.c:6181"
reproduced: false
---

# `could not find plan for CTE "%s"`

## What it means

Internal error. The planner had a `WITH` (CTE) reference but could not locate the sub-plan it should have built for that CTE. The placeholder is the CTE name. It is a consistency check that every referenced CTE has a corresponding plan.

## When it happens

It should not occur for normal queries. Reaching it points to a planner bug or an inconsistency introduced by query-tree manipulation, not to your SQL.

## How to fix

Treat it as an internal bug. If it appears only with a planner/rewrite extension, suspect that. Capture the query (and `EXPLAIN` if it reaches planning) and report it.

## Example

*Illustrative* — emitted internally during planning.

```text
ERROR:  could not find plan for CTE "cte1"
```

## Related

- [could not find CTE](./could-not-find-cte.md)
- [unrecognized result from subplan](./unrecognized-result-from-subplan.md)
