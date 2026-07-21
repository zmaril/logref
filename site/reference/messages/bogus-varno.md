---
message: "bogus varno: %d"
slug: bogus-varno
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:8551"
  - "postgres/src/backend/utils/adt/ruleutils.c:8730"
reproduced: false
---

# `bogus varno: %d`

## What it means

Internal error. While deparsing a plan for display, the code found a variable whose range-table index does not correspond to any known relation in the query. The message reports the number. It is a consistency check in the plan-to-text routines.

## When it happens

It should not occur through normal `EXPLAIN` or view display. Reaching it points to an internal inconsistency in the deparse machinery, not to your query.

## How to fix

Treat it as an internal bug. Capture the query or object being displayed and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — a bad range-table index during deparse.

```text
ERROR:  bogus varno: 8
```

## Related

- [bogus varlevelsup offset](./bogus-varlevelsup-offset.md)
- [bogus varattno for the OUTER_VAR case](./bogus-varattno-for-outer-var-var.md)
