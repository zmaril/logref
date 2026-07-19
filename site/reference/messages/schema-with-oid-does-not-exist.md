---
message: "schema with OID %u does not exist"
slug: schema-with-oid-does-not-exist
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_SCHEMA
    code: "3F000"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:3730"
  - "postgres/src/backend/commands/collationcmds.c:852"
  - "postgres/src/backend/commands/publicationcmds.c:2028"
  - "postgres/src/bin/pg_dump/pg_dump.c:6157"
reproduced: false
---

# `schema with OID %u does not exist`

## What it means

Internal error. Code looked up a schema by OID (rather than by name) and the `pg_namespace` row was gone. The placeholder is the OID. This is the OID-keyed form of a missing-schema check: something still held a schema OID after the schema was dropped, or the catalog is inconsistent.

## When it happens

Typically a schema dropped concurrently while an operation still referenced it by OID, or catalog inconsistency. It is not driven by ordinary name-based SQL, which reports the by-name error instead.

## How to fix

If it coincides with a concurrent `DROP SCHEMA`, retry — the schema is gone. If it recurs for one OID, look it up in `pg_namespace`; a missing row for an OID still referenced elsewhere indicates corruption and warrants investigation and possibly restore from backup.

## Example

*Illustrative* — a schema dropped while still referenced by OID.

```text
ERROR:  schema with OID 16480 does not exist
```

## Related

- [schema does not exist](./schema-does-not-exist.md)
- [database with OID does not exist](./database-with-oid-does-not-exist.md)
