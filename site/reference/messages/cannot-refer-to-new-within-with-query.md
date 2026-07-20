---
message: "cannot refer to NEW within WITH query"
slug: cannot-refer-to-new-within-with-query
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:3467"
reproduced: false
---

# `cannot refer to NEW within WITH query`

## What it means

A rule or trigger definition referenced `NEW` inside a `WITH` (common table expression) query. The `NEW` pseudo-relation is not visible inside a CTE, so the reference is rejected.

## When it happens

It occurs when a `CREATE RULE` action, or a similar rewrite context, places a `NEW` reference within a `WITH` query.

## How to fix

Move the `NEW` reference into the main query outside the `WITH` clause, or restructure the rule so the CTE does not need `NEW`. Pass the needed values into the CTE through the outer query instead.

## Example

*Illustrative* — NEW referenced inside a CTE.

```text
ERROR:  cannot refer to NEW within WITH query
```

## Related

- [cannot refer to OLD within WITH query](./cannot-refer-to-old-within-with-query.md)
- [cannot have multiple RETURNING lists in a rule](./cannot-have-multiple-returning-lists-in-a-rule.md)
