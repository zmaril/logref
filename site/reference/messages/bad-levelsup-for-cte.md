---
message: "bad levelsup for CTE \"%s\""
slug: bad-levelsup-for-cte
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/allpaths.c:3085"
  - "postgres/src/backend/optimizer/path/allpaths.c:3210"
  - "postgres/src/backend/optimizer/path/allpaths.c:3217"
  - "postgres/src/backend/optimizer/plan/createplan.c:3763"
  - "postgres/src/backend/optimizer/plan/createplan.c:3928"
  - "postgres/src/backend/optimizer/plan/createplan.c:3935"
  - "postgres/src/backend/parser/parse_relation.c:604"
  - "postgres/src/backend/utils/adt/selfuncs.c:6161"
reproduced: false
---

# `bad levelsup for CTE "%s"`

## What it means

Internal error. The planner tried to resolve a reference to a common table expression (CTE) at a query nesting level that does not make sense — the "levels up" count pointing to the CTE's defining query is wrong. The placeholder is the CTE name. It indicates an inconsistency in the query tree.

## When it happens

A planner bug, an extension that rewrites queries with CTEs, or a corrupted parse/plan tree. Ordinary `WITH` queries do not trigger it.

## How to fix

Treat it as a bug. If you use planner-hook or query-rewriting extensions, suspect those and check version alignment. Capture the query (especially its `WITH` structure) and a stack trace and report it.

## Example

*Illustrative* — emitted internally during CTE planning.

```text
ERROR:  bad levelsup for CTE "cte1"
```

## Related

- [unrecognized node type](./unrecognized-node-type.md)
- [too few entries in indexprs list](./too-few-entries-in-indexprs-list.md)
