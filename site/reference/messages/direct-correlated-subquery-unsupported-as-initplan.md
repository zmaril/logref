---
message: "direct correlated subquery unsupported as initplan"
slug: direct-correlated-subquery-unsupported-as-initplan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeSubplan.c:1326"
reproduced: false
---

# `direct correlated subquery unsupported as initplan`

## What it means

An internal planner/executor guard. A subplan the planner classified as an initplan turned out to be directly correlated with the outer query, which an initplan cannot be. This is a "can't happen" consistency check.

## When it happens

It fires in the subplan executor when a subquery that references outer columns was set up as an initplan, indicating an internal planning inconsistency rather than a user mistake.

## How to fix

This is not a routine user error. If a specific query reproduces it, try rewriting the correlated subquery as a join or a `LATERAL` subquery to sidestep the path. Capture the query and plan and report it to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  direct correlated subquery unsupported as initplan
```

## Related

- [DISTINCT is not implemented for window functions](./distinct-is-not-implemented-for-window-functions.md)
- [deserialfunc not provided for deserialization aggregation](./deserialfunc-not-provided-for-deserialization-aggregation.md)
