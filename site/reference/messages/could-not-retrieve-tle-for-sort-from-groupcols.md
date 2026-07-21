---
message: "could not retrieve tle for sort-from-groupcols"
slug: could-not-retrieve-tle-for-sort-from-groupcols
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/createplan.c:6505"
reproduced: false
---

# `could not retrieve tle for sort-from-groupcols`

## What it means

The planner tried to find the target-list entry a sort key came from while building a plan and could not. This is an internal consistency check: a grouping column should always map back to an entry in the query's target list.

## When it happens

It fires deep in plan creation, when a sort derived from grouping columns cannot be matched to its source expression. On correct queries and a healthy build this cannot happen.

## How to fix

This is an internal guard, not a user error. If you hit it, it points at a planner bug or a corrupted plan structure. Capture the exact query and `EXPLAIN` output and report it. There is no configuration change that is supposed to be needed.

## Example

*Illustrative* — an internal planner invariant failed.

```text
ERROR:  could not retrieve tle for sort-from-groupcols
```

## Related

- [could not translate strategy number for index AM](./could-not-translate-strategy-number-for-index-am.md)
- [could not translate compare type for index AM](./could-not-translate-compare-type-for-index-am.md)
