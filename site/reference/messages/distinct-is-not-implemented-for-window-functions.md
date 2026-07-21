---
message: "DISTINCT is not implemented for window functions"
slug: distinct-is-not-implemented-for-window-functions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:865"
reproduced: true
---

# `DISTINCT is not implemented for window functions`

## What it means

A window-function call used `DISTINCT` in its argument list, which PostgreSQL does not support. `DISTINCT` inside the parentheses of a window function is not implemented.

## When it happens

It fires during parse analysis of a call like `func(DISTINCT x) OVER (...)`.

## How to fix

Remove `DISTINCT` from the windowed call. If you need distinct behaviour, deduplicate in a subquery first (for example `SELECT DISTINCT`), then apply the window function over the deduplicated rows.

## Example

*Reproduced* — captured from `reproducers/scenarios/44_functions_operators_aggregates.sql`.

```sql
SELECT count(DISTINCT id) OVER () FROM repro.parent;
```

Produces:

```text
ERROR:  DISTINCT is not implemented for window functions
```

## Related

- [DISTINCT specified, but is not an aggregate function](./distinct-specified-but-is-not-an-aggregate-function.md)
- [direct correlated subquery unsupported as initplan](./direct-correlated-subquery-unsupported-as-initplan.md)
