---
message: "LIMIT subplan failed to run backwards"
slug: limit-subplan-failed-to-run-backwards
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeLimit.c:211"
  - "postgres/src/backend/executor/nodeLimit.c:269"
  - "postgres/src/backend/executor/nodeLimit.c:286"
  - "postgres/src/backend/executor/nodeLimit.c:305"
reproduced: false
---

# `LIMIT subplan failed to run backwards`

## What it means

Internal error. A `LIMIT` node was asked to move backwards (as a scrollable cursor can request) and its child subplan could not honor the backward scan. It is a consistency check in the executor's `LIMIT` node when reverse fetching is attempted but unsupported by the subplan state.

## When it happens

It should not occur through normal forward query execution. Reaching it involves scrollable cursors fetching backwards over a `LIMIT` in a situation the executor did not expect — an internal bug rather than a user error.

## How to fix

Treat it as an internal bug. If it appears with a specific scrollable-cursor usage over a `LIMIT` query, capture that cursor's declaration and fetch pattern and report it. Avoiding backward `FETCH` on the affected cursor is a workaround.

## Example

*Illustrative* — emitted internally on a backward LIMIT scan.

```text
ERROR:  LIMIT subplan failed to run backwards
```

## Related

- [unrecognized result from subplan](./unrecognized-result-from-subplan.md)
- [invalid tuplestore state](./invalid-tuplestore-state.md)
