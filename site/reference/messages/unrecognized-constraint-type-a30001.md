---
message: "unrecognized constraint type: %d"
slug: unrecognized-constraint-type-a30001
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/heap.c:2365"
  - "postgres/src/backend/commands/tablecmds.c:6319"
  - "postgres/src/backend/commands/tablecmds.c:6626"
  - "postgres/src/backend/commands/tablecmds.c:9986"
  - "postgres/src/backend/commands/tablecmds.c:22890"
  - "postgres/src/backend/commands/tablecmds.c:22941"
  - "postgres/src/backend/executor/execExpr.c:3649"
  - "postgres/src/backend/parser/parse_utilcmd.c:961"
  - "postgres/src/backend/parser/parse_utilcmd.c:1103"
  - "postgres/src/backend/utils/adt/domains.c:206"
reproduced: false
---

# `unrecognized constraint type: %d`

## What it means

Internal error. A `switch` over the constraint-type code (check, foreign key, primary key, unique, not-null, exclusion, and so on) hit a value it does not handle. The placeholder is the numeric constraint type. Code processing constraints reached a kind it was not written for.

## When it happens

A bug in core or in an extension that builds constraint nodes, or a version mismatch where a newer catalog contains a constraint kind an older code path does not know. Ordinary data does not trigger it.

## How to fix

Treat it as a bug. If it appears during DDL involving newer constraint kinds against older tooling, check version alignment. Capture the statement and report it with a stack trace if possible.

## Example

*Illustrative* — emitted internally during constraint handling.

```text
ERROR:  unrecognized constraint type: 9
```

## Related

- [constraint for relation already exists](./constraint-for-relation-already-exists.md)
- [unrecognized node type](./unrecognized-node-type.md)
