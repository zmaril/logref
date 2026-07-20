---
message: "invalid tuplestore state"
slug: invalid-tuplestore-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/tuplestore.c:567"
  - "postgres/src/backend/utils/sort/tuplestore.c:942"
  - "postgres/src/backend/utils/sort/tuplestore.c:1112"
  - "postgres/src/backend/utils/sort/tuplestore.c:1356"
  - "postgres/src/backend/utils/sort/tuplestore.c:1439"
reproduced: false
---

# `invalid tuplestore state`

## What it means

Internal error. A tuplestore — the buffered set of rows used by materialized nodes, `WITH HOLD` cursors, window functions, and set-returning functions — was accessed in a state its state machine does not allow. It is a consistency check on the tuplestore's own read/write mode.

## When it happens

It should not occur through normal SQL. Reaching it suggests a bug in code that drives a tuplestore (sometimes an extension implementing a set-returning function) or corrupted execution state.

## How to fix

Treat it as an internal bug. If it correlates with a specific set-returning function or extension, suspect that. Capture the query and report it.

## Example

*Illustrative* — emitted internally by the tuplestore.

```text
ERROR:  invalid tuplestore state
```

## Related

- [could not find block containing chunk](./could-not-find-block-containing-chunk.md)
- [limit subplan failed to run backwards](./limit-subplan-failed-to-run-backwards.md)
