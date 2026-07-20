---
message: "EvalPlanQual doesn't support locking rowmarks"
slug: evalplanqual-doesn-t-support-locking-rowmarks
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execMain.c:2883"
reproduced: false
---

# `EvalPlanQual doesn't support locking rowmarks`

## What it means

An internal consistency check in the executor's EvalPlanQual path, which re-evaluates a row after a concurrent update to a locked row. It found a row-mark type it is not built to re-check, and stops rather than produce a wrong result.

## When it happens

It fires deep inside `SELECT ... FOR UPDATE`/`FOR SHARE` or `UPDATE`/`DELETE` concurrency handling when the plan contains a locking row-mark that EvalPlanQual cannot process. In normal use this combination is not generated, so the message indicates an unexpected plan shape.

## How to fix

This is an internal "can't happen" guard, not something a query author sets. If you hit it, capture the exact statement, the table and index definitions, and the plan, then report it — it usually points at a planner or extension bug. There is no user-facing workaround beyond avoiding the specific query shape that triggers it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  EvalPlanQual doesn't support locking rowmarks
```

## Related

- [EvalPlanQual recheck is not supported in index-only scans](./evalplanqual-recheck-is-not-supported-in-index-only-scans.md)
- [ExecReScanModifyTable is not implemented](./execrescanmodifytable-is-not-implemented.md)
