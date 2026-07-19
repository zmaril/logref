---
message: "cannot refer to OLD within WITH query"
slug: cannot-refer-to-old-within-with-query
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:3460"
reproduced: false
---

# `cannot refer to OLD within WITH query`

## What it means

A rule or trigger definition referenced `OLD` inside a `WITH` (common table expression) query. The `OLD` pseudo-relation is not visible inside a CTE, so the reference is rejected.

## When it happens

It occurs when a `CREATE RULE` action, or a similar rewrite context, places an `OLD` reference within a `WITH` query.

## How to fix

Move the `OLD` reference into the main query outside the `WITH` clause, or restructure the rule so the CTE does not need `OLD`. Feed the needed values into the CTE from the outer query.

## Example

*Illustrative* — OLD referenced inside a CTE.

```text
ERROR:  cannot refer to OLD within WITH query
```

## Related

- [cannot refer to NEW within WITH query](./cannot-refer-to-new-within-with-query.md)
- [cannot have multiple RETURNING lists in a rule](./cannot-have-multiple-returning-lists-in-a-rule.md)
