---
message: "bogus varlevelsup: %d offset %d"
slug: bogus-varlevelsup-offset
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:8181"
  - "postgres/src/backend/utils/adt/ruleutils.c:8639"
reproduced: false
---

# `bogus varlevelsup: %d offset %d`

## What it means

Internal error. While deparsing a plan for display, the code found a variable whose query-nesting level and offset do not resolve to a valid reference. The message reports both numbers. It is a consistency check in the plan-to-text routines.

## When it happens

It should not occur through normal `EXPLAIN` or view display. Reaching it points to an internal inconsistency in how nested-query variables are tracked during deparse, not to your query.

## How to fix

Treat it as an internal bug. Capture the query or object being displayed and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — a bad nesting-level reference during deparse.

```text
ERROR:  bogus varlevelsup: 2 offset 1
```

## Related

- [bogus varno](./bogus-varno.md)
- [bogus varattno for the subquery case](./bogus-varattno-for-subquery-var.md)
