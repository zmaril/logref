---
message: "cache lookup failed for database %u"
slug: cache-lookup-failed-for-database
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3785"
  - "postgres/src/backend/catalog/objectaddress.c:5883"
  - "postgres/src/backend/commands/event_trigger.c:411"
  - "postgres/src/backend/postmaster/autovacuum.c:1980"
  - "postgres/src/backend/utils/adt/acl.c:5217"
  - "postgres/src/backend/utils/adt/pg_locale.c:1142"
  - "postgres/src/backend/utils/adt/pg_locale_builtin.c:284"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:340"
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:787"
  - "postgres/src/backend/utils/init/postinit.c:350"
reproduced: false
---

# `cache lookup failed for database %u`

## What it means

Internal error. A database's catalog row (`pg_database`) could not be found by OID. The placeholder is the database OID. Something referenced the database but the row is gone.

## When it happens

A concurrent `DROP DATABASE` racing with autovacuum, an event trigger, or an ACL operation that still held the OID, or catalog inconsistency in the shared catalog. Not caused by ordinary data.

## How to fix

If it coincides with a concurrent `DROP DATABASE`, it is expected — the database is gone. If it recurs, inspect `pg_database` for the OID; a missing row in the shared catalog is serious and warrants investigation and possibly restore. Report reproducible cases.

## Example

*Illustrative* — a database dropped mid-operation.

```text
ERROR:  cache lookup failed for database 16384
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [permission denied for database](./permission-denied-for-database.md)
