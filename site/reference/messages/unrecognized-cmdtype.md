---
message: "unrecognized CmdType: %d"
slug: unrecognized-cmdtype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execMain.c:1182"
  - "postgres/src/backend/optimizer/util/plancat.c:2545"
  - "postgres/src/backend/optimizer/util/plancat.c:2599"
  - "postgres/src/backend/replication/logical/worker.c:3658"
  - "postgres/src/backend/rewrite/rewriteHandler.c:2659"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3291"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3477"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3524"
reproduced: false
---

# `unrecognized CmdType: %d`

## What it means

Internal error. A `switch` over the executor's `CmdType` enum hit an unhandled value — the same underlying issue as "unrecognized commandType", raised from a different site. The placeholder is the numeric command type.

## When it happens

A planner/executor bug, an extension constructing query trees, or a version mismatch. Ordinary queries do not trigger it.

## How to fix

Treat it as a bug. Suspect query-rewriting or custom-node extensions and confirm version alignment. Capture the statement and a stack trace and report it.

## Example

*Illustrative* — emitted internally during execution.

```text
ERROR:  unrecognized CmdType: 42
```

## Related

- [unrecognized commandType: %d](./unrecognized-commandtype.md)
- [unrecognized node type](./unrecognized-node-type.md)
