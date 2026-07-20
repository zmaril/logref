---
message: "could not devise a query plan for the given query"
slug: could-not-devise-a-query-plan-for-the-given-query
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/pathnode.c:279"
reproduced: false
---

# `could not devise a query plan for the given query`

## What it means

The planner exhausted its path-building without producing any viable plan for a query. This is an internal guard: every query should yield at least one plan, so reaching it means the planner could not form one.

## When it happens

It fires deep in path generation, generally on an unusual query shape — often involving exotic joins, custom access methods, or planner extensions that removed the paths the core would otherwise keep.

## How to fix

This is an internal error. If a specific query triggers it, note the exact statement and any planner-related extensions or custom access methods in use, disable them to see if they are the cause, and report a reproducible case.

## Example

*Illustrative* — the planner left with no usable path.

```text
ERROR:  could not devise a query plan for the given query
```

## Related

- [could not find path for CTE](./could-not-find-path-for-cte.md)
- [could not find RelOptInfo for given relids](./could-not-find-reloptinfo-for-given-relids.md)
