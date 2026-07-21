---
message: "EvalPlanQual recheck is not supported in index-only scans"
slug: evalplanqual-recheck-is-not-supported-in-index-only-scans
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeIndexonlyscan.c:331"
reproduced: false
---

# `EvalPlanQual recheck is not supported in index-only scans`

## What it means

An internal executor guard. When a locked row is concurrently updated, EvalPlanQual re-checks the new row version, but an index-only scan node has no heap tuple to re-check, so this reports the unsupported combination.

## When it happens

It fires when a plan places an index-only scan under a row-locking clause in a way that would require an EvalPlanQual recheck. The planner normally avoids generating this shape, so the message signals an unexpected plan.

## How to fix

This is an internal invariant rather than a user setting. If it appears, record the query, the schema, and the plan and report it as a possible planner bug. As a stopgap you can discourage the index-only scan (for example by adjusting statistics or the affected index) so a plain index or sequential scan is chosen instead.

## Example

*Illustrative* — the message as logged.

```
ERROR:  EvalPlanQual recheck is not supported in index-only scans
```

## Related

- [EvalPlanQual doesn't support locking rowmarks](./evalplanqual-doesn-t-support-locking-rowmarks.md)
- [ExecReScanModifyTable is not implemented](./execrescanmodifytable-is-not-implemented.md)
