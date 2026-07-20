---
message: "unrecognized commandType: %d"
slug: unrecognized-commandtype
passthrough: false
api: [elog]
level: [ERROR, WARNING]
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:5374"
  - "postgres/src/backend/executor/nodeModifyTable.c:4045"
  - "postgres/src/backend/rewrite/rewriteHandler.c:1851"
  - "postgres/src/backend/rewrite/rewriteHandler.c:2653"
  - "postgres/src/backend/rewrite/rewriteHandler.c:3285"
  - "postgres/src/backend/rewrite/rewriteHandler.c:4321"
  - "postgres/src/backend/rewrite/rewriteHandler.c:4349"
  - "postgres/src/backend/rewrite/rewriteHandler.c:4565"
  - "postgres/src/backend/tcop/utility.c:117"
  - "postgres/src/backend/tcop/utility.c:3198"
  - "postgres/src/backend/tcop/utility.c:3261"
  - "postgres/src/backend/tcop/utility.c:3776"
  - "postgres/src/backend/tcop/utility.c:3807"
reproduced: false
---

# `unrecognized commandType: %d`

## What it means

Internal error. A `switch` over the executor's `CmdType` (SELECT, INSERT, UPDATE, DELETE, MERGE, UTILITY, and so on) hit a value it does not handle. The placeholder is the numeric command type. Code processing a query's operation reached a kind it was not written for.

## When it happens

A planner/executor bug, an extension that constructs query trees, or a version mismatch. Ordinary queries do not trigger it.

## How to fix

Treat it as a bug. If you use extensions that build or rewrite queries (rewrite rules, custom nodes), suspect those and confirm they match the server version. Capture the statement and a stack trace and report it.

## Example

*Illustrative* — emitted internally during execution.

```text
ERROR:  unrecognized commandType: 99
```

## Related

- [unrecognized CmdType](./unrecognized-cmdtype.md)
- [unrecognized node type](./unrecognized-node-type.md)
