---
message: "unrecognized boolop: %d"
slug: unrecognized-boolop-af62fb
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execExpr.c:1443"
  - "postgres/src/backend/optimizer/prep/prepqual.c:194"
  - "postgres/src/backend/optimizer/util/clauses.c:1607"
  - "postgres/src/backend/optimizer/util/clauses.c:1865"
  - "postgres/src/backend/optimizer/util/clauses.c:3260"
  - "postgres/src/backend/parser/parse_expr.c:1447"
  - "postgres/src/backend/utils/adt/ruleutils.c:10073"
reproduced: false
---

# `unrecognized boolop: %d`

## What it means

Internal error. A `switch` over the boolean-operator kind (`AND`, `OR`, `NOT`) in an expression node hit a value it does not handle. The placeholder is the numeric `BoolExprType`. Code processing a boolean expression reached an unexpected kind.

## When it happens

A planner/executor bug, an extension building boolean expression nodes, or memory corruption. Ordinary `AND`/`OR`/`NOT` expressions do not trigger it.

## How to fix

Treat it as a bug. Suspect expression-rewriting extensions and confirm version alignment. Capture the query and a stack trace and report it.

## Example

*Illustrative* — emitted internally during expression handling.

```text
ERROR:  unrecognized boolop: 3
```

## Related

- [unrecognized booltesttype](./unrecognized-booltesttype.md)
- [unrecognized nulltesttype](./unrecognized-nulltesttype.md)
