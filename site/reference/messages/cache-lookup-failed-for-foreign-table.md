---
message: "cache lookup failed for foreign table %u"
slug: cache-lookup-failed-for-foreign-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/heap.c:1877"
  - "postgres/src/backend/foreign/foreign.c:296"
  - "postgres/src/backend/foreign/foreign.c:395"
reproduced: false
---

# `cache lookup failed for foreign table %u`

## What it means

Internal error. A foreign table's catalog row (`pg_foreign_table`) could not be found by OID. The placeholder is the relation OID. Code expected the foreign-table entry to exist because a relation still referenced it.

## When it happens

A concurrent `DROP FOREIGN TABLE`, or catalog inconsistency between `pg_class` and `pg_foreign_table`. Not caused by ordinary data.

## How to fix

If concurrent DDL dropped the foreign table, retry. If it recurs for one OID, inspect `pg_foreign_table`/`pg_class`; a missing entry for a live relation OID indicates corruption. Report reproducible cases.

## Example

*Illustrative* — a foreign table dropped concurrently.

```text
ERROR:  cache lookup failed for foreign table 16512
```

## Related

- [cache lookup failed for user mapping](./cache-lookup-failed-for-user-mapping.md)
- [foreign-data wrapper does not exist](./foreign-data-wrapper-does-not-exist.md)
