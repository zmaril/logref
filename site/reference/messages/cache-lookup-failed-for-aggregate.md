---
message: "cache lookup failed for aggregate %u"
slug: cache-lookup-failed-for-aggregate
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeAgg.c:3786"
  - "postgres/src/backend/executor/nodeWindowAgg.c:2970"
  - "postgres/src/backend/optimizer/prep/prepagg.c:152"
  - "postgres/src/backend/parser/parse_func.c:381"
  - "postgres/src/backend/utils/adt/ruleutils.c:3711"
reproduced: false
---

# `cache lookup failed for aggregate %u`

## What it means

Internal error. Code looked up an aggregate function's catalog row (`pg_aggregate`) by OID and found nothing. The placeholder is the OID. A missing row for an OID the code is actively using usually means the aggregate was dropped concurrently or the catalog is inconsistent.

## When it happens

Most often a concurrent `DROP AGGREGATE` while a query referencing it is planned or executed; otherwise catalog inconsistency. It is not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry — the aggregate was dropped out from under the query. If it recurs with no concurrent drops, inspect the aggregate and its dependencies; a genuinely missing row is corruption warranting investigation.

## Example

*Illustrative* — a concurrently dropped aggregate.

```text
ERROR:  cache lookup failed for aggregate 16401
```

## Related

- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)
- [cache lookup failed for language](./cache-lookup-failed-for-language.md)
