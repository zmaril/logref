---
message: "bogus varattno for INDEX_VAR var: %d"
slug: bogus-varattno-for-index-var-var
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:8544"
  - "postgres/src/backend/utils/adt/ruleutils.c:8719"
reproduced: false
---

# `bogus varattno for INDEX_VAR var: %d`

## What it means

Internal error. While turning a plan back into readable SQL (for `EXPLAIN` or rule display), the code found an index-scan variable whose attribute number does not correspond to a real output column. The message reports the number. It is a consistency check in the plan-to-text routines.

## When it happens

It should not occur through normal `EXPLAIN` or view display. Reaching it points to an internal inconsistency in the deparse machinery, not to your query.

## How to fix

Treat it as an internal bug. Capture the query or object being displayed and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — a bad attribute number during deparse.

```text
ERROR:  bogus varattno for INDEX_VAR var: 5
```

## Related

- [bogus varattno for the OUTER_VAR case](./bogus-varattno-for-outer-var-var.md)
- [bogus varattno for the INNER_VAR case](./bogus-varattno-for-inner-var-var.md)
