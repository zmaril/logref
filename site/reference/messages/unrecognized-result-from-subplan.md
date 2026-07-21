---
message: "unrecognized result from subplan"
slug: unrecognized-result-from-subplan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeBitmapAnd.c:141"
  - "postgres/src/backend/executor/nodeBitmapHeapscan.c:113"
  - "postgres/src/backend/executor/nodeBitmapHeapscan.c:123"
  - "postgres/src/backend/executor/nodeBitmapOr.c:159"
  - "postgres/src/backend/executor/nodeBitmapOr.c:167"
reproduced: false
---

# `unrecognized result from subplan`

## What it means

Internal error. A node that combines subplan results (here a bitmap AND/OR node) received a result value from its child that is none of the expected kinds. It is a consistency check on the executor's node protocol.

## When it happens

It should not occur for normal query execution. Reaching it points to a bug in the executor or in a custom scan/extension node, not to your data.

## How to fix

Treat it as an internal bug. If it correlates with a custom scan provider or executor extension, suspect that. Capture the query plan (`EXPLAIN`) and report it.

## Example

*Illustrative* — emitted internally by a bitmap node.

```text
ERROR:  unrecognized result from subplan
```

## Related

- [unknown action in MERGE WHEN clause](./unknown-action-in-merge-when-clause.md)
- [limit subplan failed to run backwards](./limit-subplan-failed-to-run-backwards.md)
