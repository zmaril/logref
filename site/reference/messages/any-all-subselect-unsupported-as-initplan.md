---
message: "ANY/ALL subselect unsupported as initplan"
slug: any-all-subselect-unsupported-as-initplan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeSubplan.c:1133"
reproduced: false
---

# `ANY/ALL subselect unsupported as initplan`

## What it means

The planner reached a state where an `ANY`/`ALL` subselect would have to become an initplan, a form it does not support in that position — an internal planner guard.

## When it happens

It is raised on an internal planning path when a sub-select that should have been handled as a correlated or hashed subplan instead appears where only an initplan would fit, generally through a planner bug or unusual construct.

## How to fix

This is an internal error, not something to rewrite at the SQL surface with certainty. If a specific query reproduces it, try restructuring the `ANY`/`ALL` sub-select (for example as an `EXISTS`/`IN` join or an explicit join), and report the original query with `EXPLAIN` output.

## Example

*Illustrative* — an unsupported ANY/ALL subselect as an initplan.

```text
ERROR:  ANY/ALL subselect unsupported as initplan
```

## Related

- [already-planned subqueries not supported](./already-planned-subqueries-not-supported.md)
- [Aggref found where not expected](./aggref-found-where-not-expected.md)
