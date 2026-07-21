---
message: "could not find RecursiveUnion for WorkTableScan with wtParam %d"
slug: could-not-find-recursiveunion-for-worktablescan-with-wtparam
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:5609"
reproduced: false
---

# `could not find RecursiveUnion for WorkTableScan with wtParam %d`

## What it means

`pg_get_viewdef` and related deparse code could not find the RecursiveUnion node that a WorkTableScan belongs to. The `%d` is the work-table parameter. This is an internal invariant of recursive-query deparsing.

## When it happens

It fires while deparsing a plan or view definition that contains a recursive CTE, when the work-table scan cannot be matched to its recursive union. Ordinary usage does not reach it.

## How to fix

This is an internal error. If deparsing a specific recursive view or query triggers it, note the exact definition and report a reproducible case.

## Example

*Illustrative* — an unmatched work-table scan during deparse.

```text
ERROR:  could not find RecursiveUnion for WorkTableScan with wtParam 2
```

## Related

- [could not find plan for CteScan referencing plan ID](./could-not-find-plan-for-ctescan-referencing-plan-id.md)
- [could not find path for CTE](./could-not-find-path-for-cte.md)
