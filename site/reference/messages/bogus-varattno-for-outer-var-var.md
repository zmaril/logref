---
message: "bogus varattno for OUTER_VAR var: %d"
slug: bogus-varattno-for-outer-var-var
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:8500"
  - "postgres/src/backend/utils/adt/ruleutils.c:8682"
reproduced: false
---

# `bogus varattno for OUTER_VAR var: %d`

## What it means

Internal error. While deparsing a plan for display, the code found an outer-join variable whose attribute number does not correspond to a real output column. The message reports the number. It is a consistency check in the plan-to-text routines.

## When it happens

It should not occur through normal `EXPLAIN` or view display. Reaching it points to an internal inconsistency in the deparse machinery, not to your query.

## How to fix

Treat it as an internal bug. Capture the query or object being displayed and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — a bad outer-var attribute number.

```text
ERROR:  bogus varattno for OUTER_VAR var: 3
```

## Related

- [bogus varattno for the INNER_VAR case](./bogus-varattno-for-inner-var-var.md)
- [bogus varattno for the subquery case](./bogus-varattno-for-subquery-var.md)
