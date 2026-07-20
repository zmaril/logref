---
message: "set-returning functions must appear at top level of FROM"
slug: set-returning-functions-must-appear-at-top-level-of-from
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:571"
  - "postgres/src/backend/parser/parse_clause.c:599"
  - "postgres/src/backend/parser/parse_func.c:2683"
reproduced: false
---

# `set-returning functions must appear at top level of FROM`

## What it means

A set-returning function appeared nested inside an expression in the `FROM` clause rather than as a top-level `FROM` item. When used in `FROM`, a set-returning function must stand on its own, not be buried inside another expression there.

## When it happens

Writing a `FROM` entry that wraps a set-returning function inside a larger expression, instead of listing the function directly as a `FROM` item.

## How to fix

List the set-returning function as its own `FROM` item, optionally with `LATERAL` to reference earlier items, and join to it. If you need to transform its output, do so in the target list or a surrounding query rather than nesting the function inside a `FROM` expression.

## Example

*Illustrative* — a set-returning function nested in FROM.

```sql
SELECT * FROM (generate_series(1,3) + 1);  -- list the SRF as its own FROM item
```

## Related

- [set-returning functions are not allowed in](./set-returning-functions-are-not-allowed-in.md)
- [set-valued function called in context that cannot accept a set](./set-valued-function-called-in-context-that-cannot-accept-a-set.md)
