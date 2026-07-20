---
message: "unrecognized set op: %d"
slug: unrecognized-set-op
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeSetOp.c:158"
  - "postgres/src/backend/optimizer/prep/prepunion.c:1289"
  - "postgres/src/backend/parser/parse_cte.c:1266"
  - "postgres/src/backend/utils/adt/ruleutils.c:6881"
reproduced: false
---

# `unrecognized set op: %d`

## What it means

Internal error. Executor code for set operations (`UNION`/`INTERSECT`/`EXCEPT`) received a set-operation strategy tag it does not handle. The placeholder is the numeric tag. The strategy should always be one the planner produced, so an unrecognized value is a consistency guard.

## When it happens

It does not arise from ordinary SQL. Reaching it indicates a planner/executor mismatch — a bug — rather than anything in the query text itself.

## How to fix

Treat it as an internal bug. Capture the query (especially its `UNION`/`INTERSECT`/`EXCEPT` structure) and its plan, and report it. There is no user-side change expected to trigger or avoid it.

## Example

*Illustrative* — emitted internally during a set operation.

```text
ERROR:  unrecognized set op: 7
```

## Related

- [unrecognized GrantStmt.objtype](./unrecognized-grantstmt-objtype.md)
- [unsupported indexqual type](./unsupported-indexqual-type.md)
