---
message: "could not find CTE \"%s\""
slug: could-not-find-cte
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/allpaths.c:3103"
  - "postgres/src/backend/optimizer/plan/createplan.c:3781"
  - "postgres/src/backend/parser/parse_relation.c:614"
  - "postgres/src/backend/utils/adt/selfuncs.c:6179"
reproduced: false
---

# `could not find CTE "%s"`

## What it means

Internal error. The planner resolving a `WITH` (CTE) reference by name did not find the matching CTE in scope. The placeholder is the CTE name. By the time planning runs, every CTE reference should resolve; a missing one indicates an inconsistent query tree.

## When it happens

It should not occur for queries the parser accepted. Reaching it points to a bug in query rewriting/planning, sometimes involving an extension that manipulates query trees, not to your SQL as written.

## How to fix

Treat it as an internal bug. If it correlates with an extension that rewrites queries, suspect that. Capture the exact query and report it.

## Example

*Illustrative* — emitted internally during planning.

```text
ERROR:  could not find CTE "cte1"
```

## Related

- [could not find plan for CTE](./could-not-find-plan-for-cte.md)
- [unrecognized RTE kind](./unrecognized-rte-kind.md)
