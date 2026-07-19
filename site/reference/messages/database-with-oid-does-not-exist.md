---
message: "database with OID %u does not exist"
slug: database-with-oid-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:527"
  - "postgres/src/backend/utils/adt/dbsize.c:178"
  - "postgres/src/backend/utils/adt/ddlutils.c:675"
reproduced: false
---

# `database with OID %u does not exist`

## What it means

Code looked up a database by OID and found no `pg_database` row. The placeholder is the OID. It surfaces from functions and paths that resolve a database OID (for example collation or size functions) when the database was dropped or the OID is stale.

## When it happens

Referencing a database by an OID that no longer exists — a concurrent `DROP DATABASE`, a stale OID captured earlier, or a query joining against an outdated value.

## How to fix

Use a current database OID or name — `SELECT oid, datname FROM pg_database` lists the live ones. Refresh any stored OID, and if a database was dropped concurrently, simply use a valid one. Not a data error in your tables.

## Example

*Illustrative* — a function given a dropped database OID.

```text
ERROR:  database with OID 99999 does not exist
```

## Related

- [schema with OID does not exist](./schema-with-oid-does-not-exist.md)
- [tablespace with OID does not exist](./tablespace-with-oid-does-not-exist.md)
