---
message: "cache lookup failed for namespace %u"
slug: cache-lookup-failed-for-namespace
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3562"
  - "postgres/src/backend/catalog/objectaddress.c:5672"
  - "postgres/src/backend/replication/logical/proto.c:1039"
  - "postgres/src/backend/utils/adt/ruleutils.c:14313"
  - "postgres/src/backend/utils/cache/lsyscache.c:3727"
reproduced: false
---

# `cache lookup failed for namespace %u`

## What it means

Internal error. Code looked up a schema (namespace) catalog row (`pg_namespace`) by OID and found nothing. The placeholder is the OID. A missing row for an OID in active use points to a concurrent drop or catalog inconsistency.

## When it happens

Typically a concurrent `DROP SCHEMA` while an operation referencing it runs; otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If concurrent DDL was in flight, retry. If it recurs, inspect the schema and dependencies; a persistently missing row indicates corruption warranting investigation and possibly a restore.

## Example

*Illustrative* — a concurrently dropped schema.

```text
ERROR:  cache lookup failed for namespace 16403
```

## Related

- [cache lookup failed for role](./cache-lookup-failed-for-role.md)
- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)
