---
message: "could not find tuple for database %u"
slug: could-not-find-tuple-for-database
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/sepgsql/database.c:89"
  - "postgres/src/backend/commands/event_trigger.c:980"
  - "postgres/src/backend/commands/vacuum.c:1768"
reproduced: false
---

# `could not find tuple for database %u`

## What it means

Internal error. Code (here the `sepgsql` extension) looked up a database's `pg_database` row by OID and found none. The placeholder is the database OID. A database the operation referenced was expected to have a catalog row that was missing.

## When it happens

A concurrent `DROP DATABASE`, or catalog inconsistency. Not driven by ordinary data. With `sepgsql` it surfaces while computing security labels for a database.

## How to fix

If a database was dropped concurrently, retry. If it recurs for one OID, inspect `pg_database`; a dangling reference indicates corruption. When `sepgsql` is involved, confirm its configuration and version match the server. Report reproducible cases.

## Example

*Illustrative* — a database row not found.

```text
ERROR:  could not find tuple for database 16400
```

## Related

- [database with OID does not exist](./database-with-oid-does-not-exist.md)
- [could not find tuple for default ACL](./could-not-find-tuple-for-default-acl.md)
