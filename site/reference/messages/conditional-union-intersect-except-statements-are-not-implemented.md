---
message: "conditional UNION/INTERSECT/EXCEPT statements are not implemented"
slug: conditional-union-intersect-except-statements-are-not-implemented
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:3395"
  - "postgres/src/backend/parser/parse_utilcmd.c:3496"
  - "postgres/src/backend/rewrite/rewriteHandler.c:545"
  - "postgres/src/backend/rewrite/rewriteManip.c:1184"
reproduced: false
---

# `conditional UNION/INTERSECT/EXCEPT statements are not implemented`

## What it means

A set operation (`UNION`/`INTERSECT`/`EXCEPT`) was written in a conditional/CASE-like construct where Postgres does not support it. The parser rejects this combination as a not-yet-implemented feature rather than producing a wrong result.

## When it happens

Building a query that places a set operation inside a context — such as certain conditional expression forms — where set operations are not permitted.

## How to fix

Rewrite the query to move the set operation to the top level of a subquery, then reference that subquery. Wrap each `UNION`/`INTERSECT`/`EXCEPT` in its own subselect (`SELECT ... FROM (SELECT ... UNION SELECT ...) s`) instead of embedding it in the unsupported context.

## Example

*Illustrative* — a set operation in an unsupported position.

```text
ERROR:  conditional UNION/INTERSECT/EXCEPT statements are not implemented
```

## Related

- [is not allowed with UNION/INTERSECT/EXCEPT](./is-not-allowed-with-union-intersect-except.md)
- [an edge cannot connect more than two vertices even in a cyclic pattern](./an-edge-cannot-connect-more-than-two-vertices-even-in-a-cyclic-pattern.md)
