---
message: "empty query does not return tuples"
slug: empty-query-does-not-return-tuples
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/executor/spi.c:2494"
reproduced: false
---

# `empty query does not return tuples`

## What it means

SPI was asked to run a query and fetch rows, but the supplied query string was empty (or contained only comments/whitespace). An empty query produces no result set.

## When it happens

It fires from SPI-based code (PL/pgSQL, extensions) when a function expected to return rows is handed an empty query text.

## How to fix

Make sure the query string passed to the SPI call is non-empty and actually a `SELECT` (or another row-returning statement). In PL/pgSQL, check that a variable holding dynamic SQL is not empty before `EXECUTE ... INTO`.

## Example

*Illustrative* — running an empty query for rows.

```sql
EXECUTE '' INTO x;
-- empty query does not return tuples
```

## Related

- [empty query](./empty-query.md)
- [each query must have the same number of columns](./each-query-must-have-the-same-number-of-columns.md)
