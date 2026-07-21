---
message: "ExecReScanModifyTable is not implemented"
slug: execrescanmodifytable-is-not-implemented
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:5896"
reproduced: false
---

# `ExecReScanModifyTable is not implemented`

## What it means

An internal executor guard. A plan asked to rescan a `ModifyTable` node (the node that runs `INSERT`/`UPDATE`/`DELETE`/`MERGE`), which the executor does not support, so it stops rather than run a data-modifying node twice.

## When it happens

It fires when a plan shape would place a data-modifying operation where the executor needs to rescan its input, such as certain nestings of a writable CTE. The planner normally prevents this, so reaching it is unexpected.

## How to fix

This is an internal invariant, not a user setting. If a straightforward query hits it, rewrite the statement to avoid nesting the data-modifying part where it could be rescanned — for example split a writable CTE out of a correlated context. Capture the statement and report it, since it usually indicates a planner bug.

## Example

*Illustrative* — the message as logged.

```
ERROR:  ExecReScanModifyTable is not implemented
```

## Related

- [EvalPlanQual doesn't support locking rowmarks](./evalplanqual-doesn-t-support-locking-rowmarks.md)
- [executor could not find named tuplestore](./executor-could-not-find-named-tuplestore.md)
