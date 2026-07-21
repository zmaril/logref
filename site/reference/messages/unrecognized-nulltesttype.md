---
message: "unrecognized nulltesttype: %d"
slug: unrecognized-nulltesttype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execExpr.c:2520"
  - "postgres/src/backend/executor/nodeIndexscan.c:1615"
  - "postgres/src/backend/optimizer/util/clauses.c:3925"
  - "postgres/src/backend/optimizer/util/clauses.c:3948"
  - "postgres/src/backend/utils/adt/ruleutils.c:10832"
  - "postgres/src/backend/utils/adt/ruleutils.c:10847"
  - "postgres/src/backend/utils/adt/selfuncs.c:1818"
  - "postgres/src/backend/utils/adt/selfuncs.c:1846"
reproduced: false
---

# `unrecognized nulltesttype: %d`

## What it means

Internal error. A `switch` over the `NullTestType` enum (`IS NULL`, `IS NOT NULL`) hit a value it does not handle. The placeholder is the numeric value. Code processing a null-test expression reached an unexpected kind.

## When it happens

A planner/executor bug, an extension building expression nodes, or memory corruption. Ordinary `IS NULL`/`IS NOT NULL` expressions do not trigger it.

## How to fix

Treat it as a bug. Suspect expression-rewriting extensions and confirm version alignment. Capture the query and a stack trace and report it.

## Example

*Illustrative* — emitted internally during expression handling.

```text
ERROR:  unrecognized nulltesttype: 5
```

## Related

- [unrecognized booltesttype](./unrecognized-booltesttype.md)
- [unrecognized node type](./unrecognized-node-type.md)
