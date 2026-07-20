---
message: "bogus varattno for subquery var: %d"
slug: bogus-varattno-for-subquery-var
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:8840"
  - "postgres/src/backend/utils/adt/ruleutils.c:8972"
reproduced: false
---

# `bogus varattno for subquery var: %d`

## What it means

Internal error. While deparsing a plan for display, the code found a subquery variable whose attribute number does not correspond to a real output column of that subquery. The message reports the number. It is a consistency check in the plan-to-text routines.

## When it happens

It should not occur through normal `EXPLAIN` or view display. Reaching it points to an internal inconsistency in the deparse machinery, not to your query.

## How to fix

Treat it as an internal bug. Capture the query or object being displayed and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — a bad subquery-var attribute number.

```text
ERROR:  bogus varattno for subquery var: 6
```

## Related

- [bogus varattno for the OUTER_VAR case](./bogus-varattno-for-outer-var-var.md)
- [bogus varno](./bogus-varno.md)
