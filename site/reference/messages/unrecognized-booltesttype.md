---
message: "unrecognized booltesttype: %d"
slug: unrecognized-booltesttype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execExpr.c:2570"
  - "postgres/src/backend/optimizer/prep/prepqual.c:249"
  - "postgres/src/backend/optimizer/util/clauses.c:4012"
  - "postgres/src/backend/optimizer/util/clauses.c:4045"
  - "postgres/src/backend/parser/parse_expr.c:2587"
  - "postgres/src/backend/utils/adt/ruleutils.c:10884"
  - "postgres/src/backend/utils/adt/selfuncs.c:1692"
  - "postgres/src/backend/utils/adt/selfuncs.c:1729"
  - "postgres/src/backend/utils/adt/selfuncs.c:1765"
reproduced: false
---

# `unrecognized booltesttype: %d`

## What it means

Internal error. A `switch` over the `BoolTestType` enum (`IS TRUE`, `IS NOT TRUE`, `IS FALSE`, `IS NOT FALSE`, `IS UNKNOWN`, `IS NOT UNKNOWN`) hit a value it does not handle. The placeholder is the numeric value. Code processing a boolean test expression reached an unexpected kind.

## When it happens

A planner/executor bug, an extension building expression nodes, or memory corruption. Ordinary `IS TRUE`/`IS FALSE` expressions do not trigger it.

## How to fix

Treat it as a bug. If you use extensions that construct or rewrite expressions, suspect those. Capture the query and a stack trace and report it.

## Example

*Illustrative* — emitted internally during expression handling.

```text
ERROR:  unrecognized booltesttype: 99
```

## Related

- [unrecognized nulltesttype](./unrecognized-nulltesttype.md)
- [unrecognized node type](./unrecognized-node-type.md)
