---
message: "CTE %s does not have attribute %d"
slug: cte-does-not-have-attribute
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_target.c:420"
  - "postgres/src/backend/parser/parse_target.c:1666"
  - "postgres/src/backend/utils/adt/ruleutils.c:8908"
reproduced: false
---

# `CTE %s does not have attribute %d`

## What it means

Internal error. During parse analysis, code referenced a column of a common table expression (CTE) by attribute number that the CTE's output does not contain. The placeholders are the CTE name and the attribute number. Column references should resolve to real CTE output columns, so a missing one is a consistency check.

## When it happens

It does not arise from ordinary SQL, which reports a by-name column error. Reaching this internal form points to a bug in query rewriting or in code that builds queries with CTEs programmatically.

## How to fix

Treat it as an internal bug. If it appears with a specific view, rule, or generated query using `WITH`, capture that definition and the statement and report it. There is no data-side change expected to trigger or avoid it.

## Example

*Illustrative* — emitted internally during parse analysis.

```text
ERROR:  CTE cte does not have attribute 3
```

## Related

- [subquery does not have attribute](./subquery-does-not-have-attribute.md)
- [expected to find SELECT subquery](./expected-to-find-select-subquery.md)
