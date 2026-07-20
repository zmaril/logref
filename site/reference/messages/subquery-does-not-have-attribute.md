---
message: "subquery %s does not have attribute %d"
slug: subquery-does-not-have-attribute
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_target.c:374"
  - "postgres/src/backend/parser/parse_target.c:1607"
  - "postgres/src/backend/utils/adt/ruleutils.c:8772"
  - "postgres/src/backend/utils/adt/selfuncs.c:6225"
reproduced: false
---

# `subquery %s does not have attribute %d`

## What it means

Internal error. During parse analysis or rewriting, code referenced a column of a subquery by attribute number that the subquery's target list does not contain. The placeholders are the subquery alias and the attribute number. The column reference should always resolve to a real output column, so a missing one is a consistency check.

## When it happens

It does not arise from ordinary SQL, which reports a by-name `column does not exist` error instead. Reaching this internal form points to a bug in query rewriting or in code that constructs queries programmatically.

## How to fix

Treat it as an internal bug. If it appears with a specific view, rule, or generated query, capture that definition and the failing statement and report it. There is no data-side change expected to trigger or avoid it.

## Example

*Illustrative* — emitted internally during parse analysis.

```text
ERROR:  subquery sub does not have attribute 3
```

## Related

- [CTE does not have attribute](./cte-does-not-have-attribute.md)
- [expected to find SELECT subquery](./expected-to-find-select-subquery.md)
