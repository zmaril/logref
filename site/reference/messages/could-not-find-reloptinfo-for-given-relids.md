---
message: "could not find RelOptInfo for given relids"
slug: could-not-find-reloptinfo-for-given-relids
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/selfuncs.c:7408"
reproduced: false
---

# `could not find RelOptInfo for given relids`

## What it means

Selectivity estimation could not find the `RelOptInfo` describing a set of relations it was asked about. This is an internal guard in the planner's statistics code.

## When it happens

It fires while the planner estimates selectivity for a join or clause and the relation-set descriptor it needs is missing. Ordinary queries do not reach it.

## How to fix

This is an internal error. If a specific query triggers it, note the exact statement (especially complex joins or extended statistics in use) and report a reproducible case.

## Example

*Illustrative* — a missing RelOptInfo during estimation.

```text
ERROR:  could not find RelOptInfo for given relids
```

## Related

- [could not devise a query plan for the given query](./could-not-devise-a-query-plan-for-the-given-query.md)
- [could not find memoization table entry](./could-not-find-memoization-table-entry.md)
