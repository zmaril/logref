---
message: "unknown action in MERGE WHEN clause"
slug: unknown-action-in-merge-when-clause
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execPartition.c:1143"
  - "postgres/src/backend/executor/nodeModifyTable.c:3755"
  - "postgres/src/backend/executor/nodeModifyTable.c:4312"
  - "postgres/src/backend/parser/parse_merge.c:167"
  - "postgres/src/backend/parser/parse_merge.c:393"
reproduced: false
---

# `unknown action in MERGE WHEN clause`

## What it means

Internal error. Executor code dispatching on a `MERGE` `WHEN` clause's action (INSERT, UPDATE, DELETE, DO NOTHING) reached an action value it does not recognize. It is a switch-default guard over a fixed set of merge actions.

## When it happens

It should not occur for a `MERGE` the parser accepted. Reaching it indicates an internal bug in `MERGE` execution or a mismatch in plan state, not a problem with your statement.

## How to fix

Treat it as an internal bug. If reproducible, capture the exact `MERGE` statement and table definitions and report it.

## Example

*Illustrative* — emitted internally during MERGE execution.

```text
ERROR:  unknown action in MERGE WHEN clause
```

## Related

- [unrecognized result from subplan](./unrecognized-result-from-subplan.md)
- [unexpected partition strategy](./unexpected-partition-strategy.md)
