---
message: "unexpected result from deparseAnalyzeInfoSql query"
slug: unexpected-result-from-deparseanalyzeinfosql-query
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:5198"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:5850"
reproduced: false
---

# `unexpected result from deparseAnalyzeInfoSql query`

## What it means

Internal error. In `postgres_fdw`, the query that reads a remote table's analyze-info returned a result shape the extension did not expect.

## When it happens

It fires during `ANALYZE` of a foreign table when the remote server's answer to the info query does not have the assumed columns or row count — a version mismatch or an altered remote catalog.

## How to fix

This is an internal guard in `postgres_fdw`. Confirm the remote server is a compatible PostgreSQL version and the foreign table maps to a real table; if both hold and it recurs, report it with both server versions.

## Example

*Illustrative* — an unexpected remote analyze-info result.

```text
ERROR:  unexpected result from deparseAnalyzeInfoSql query
```

## Related

- [unsupported join alias expression](./unsupported-join-alias-expression.md)
- [unexpected PQresultStatus: %d](./unexpected-pqresultstatus.md)
