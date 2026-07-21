---
message: "unsupported join alias expression"
slug: unsupported-join-alias-expression
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/var.c:1227"
  - "postgres/src/backend/optimizer/util/var.c:1242"
reproduced: false
---

# `unsupported join alias expression`

## What it means

Internal error in `postgres_fdw`. While deparsing a query to send to a remote server, the extension met a join-alias expression it does not know how to render remotely.

## When it happens

It fires during remote-query construction for a foreign join when a `USING`/alias-merged column produces an expression outside the shapes the deparser handles.

## How to fix

This is a guard in the FDW deparser. Rewriting the query to avoid the unusual join alias, or disabling remote join pushdown for that query, works around it; capture the query and report it if a common shape triggers it.

## Example

*Illustrative* — an undeparsable join alias.

```text
ERROR:  unsupported join alias expression
```

## Related

- [unexpected result from deparseAnalyzeInfoSql query](./unexpected-result-from-deparseanalyzeinfosql-query.md)
- [unsupported join type %d](./unsupported-join-type.md)
