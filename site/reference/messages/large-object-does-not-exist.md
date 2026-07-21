---
message: "large object %u does not exist"
slug: large-object-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:3610"
  - "postgres/src/backend/catalog/objectaddress.c:1147"
  - "postgres/src/backend/catalog/pg_largeobject.c:125"
  - "postgres/src/backend/libpq/be-fsstubs.c:321"
  - "postgres/src/backend/storage/large_object/inv_api.c:245"
reproduced: true
---

# `large object %u does not exist`

## What it means

A large-object operation referenced a large object by OID that does not exist. The placeholder is the OID. Large objects live in `pg_largeobject`/`pg_largeobject_metadata`; referencing one that was never created or has been unlinked produces this.

## When it happens

Calling `lo_open`, `lo_read`, `loread`, `lo_unlink`, `lo_export`, or the `SELECT`-level large-object functions with an OID that does not correspond to an existing large object, or one removed by another session.

## How to fix

Confirm the large object exists — `SELECT oid FROM pg_largeobject_metadata WHERE oid = ...` — and that you are using the OID returned by `lo_create`/`lo_import`. Recreate or re-import the object if it was removed. Watch for large objects orphaned or deleted by `vacuumlo` or application cleanup.

## Example

*Reproduced* — captured from `reproducers/scenarios/22_system_admin_funcs.sql`.

```sql
SELECT lo_get(999999999);
```

Produces:

```text
ERROR:  large object 999999999 does not exist
```

## Related

- [permission denied for large object](./permission-denied-for-large-object.md)
- [replication slot does not exist](./replication-slot-does-not-exist.md)
