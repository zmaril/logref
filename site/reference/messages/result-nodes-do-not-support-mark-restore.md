---
message: "Result nodes do not support mark/restore"
slug: result-nodes-do-not-support-mark-restore
passthrough: false
api: [elog]
level: [DEBUG2, ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeResult.c:153"
  - "postgres/src/backend/executor/nodeResult.c:168"
reproduced: false
---

# `Result nodes do not support mark/restore`

## What it means

Internal executor note/error. A `Result` plan node was asked to support the mark/restore protocol (used by merge joins to rewind an input to a marked position), which it does not implement. The planner should not place a `Result` where mark/restore is required.

## When it happens

It fires when the executor's mark/restore path reaches a `Result` node. In normal planning a materialize node is inserted to provide mark/restore; reaching this indicates an unexpected plan shape. It can also appear at DEBUG2 as an informational note.

## How to fix

This is an internal consistency guard. If it surfaces as an error for a real query, capture the statement and report it as a planner bug.

## Example

*Illustrative* — a merge join asking a Result node to mark/restore.

```text
ERROR:  Result nodes do not support mark/restore
```

## Related

- [outer pathkeys do not match mergeclauses](./outer-pathkeys-do-not-match-mergeclauses.md)
- [retrieved too many tuples in a bounded sort](./retrieved-too-many-tuples-in-a-bounded-sort.md)
