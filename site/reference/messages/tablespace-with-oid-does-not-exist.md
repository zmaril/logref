---
message: "tablespace with OID %u does not exist"
slug: tablespace-with-oid-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/utils/adt/dbsize.c:291"
  - "postgres/src/backend/utils/adt/ddlutils.c:493"
  - "postgres/src/backend/utils/adt/ddlutils.c:788"
  - "postgres/src/backend/utils/adt/genfile.c:655"
reproduced: false
---

# `tablespace with OID %u does not exist`

## What it means

Code looked up a tablespace by OID and found no matching `pg_tablespace` row. The placeholder is the OID. It surfaces from functions that resolve a tablespace OID to a name or path — most commonly the size/location functions — when the tablespace was dropped or the OID is stale.

## When it happens

Calling `pg_tablespace_size`, `pg_tablespace_location`, or similar with an OID that no longer exists, or referencing a tablespace by OID after a concurrent `DROP TABLESPACE`.

## How to fix

Use a current tablespace OID or name — `SELECT oid, spcname FROM pg_tablespace` lists the live ones. If a query joined against a stale OID, refresh it. If it followed a concurrent drop, simply retry with a valid tablespace.

## Example

*Illustrative* — a size function on a dropped tablespace.

```sql
SELECT pg_tablespace_size(99999);  -- tablespace with OID 99999 does not exist
```

## Related

- [only shared relations can be placed in pg_global tablespace](./only-shared-relations-can-be-placed-in-pg-global-tablespace.md)
- [database with OID does not exist](./database-with-oid-does-not-exist.md)
