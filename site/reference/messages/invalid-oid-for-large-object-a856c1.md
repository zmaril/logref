---
message: "invalid OID for large object"
slug: invalid-oid-for-large-object-a856c1
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:375"
  - "postgres/src/bin/pg_dump/pg_backup_null.c:143"
reproduced: false
---

# `invalid OID for large object`

## What it means

A large-object operation was given an OID that is not valid for a large object — typically OID `0` (`InvalidOid`), which cannot name a large object. The operation is refused.

## When it happens

It arises from the large-object API (`lo_open`, `lo_unlink`, `lo_export`, and relatives) when the large-object OID argument is zero or otherwise not a real large-object identifier.

## How to fix

Pass the OID of an existing large object, such as the value returned by `lo_create`/`lo_import`. Check that the variable holding the OID was set and is not zero. List existing large objects with `\dl` in psql.

## Example

*Illustrative* — opening a large object with OID 0.

```sql
SELECT lo_open(0, 131072);  -- invalid OID for large object
```

## Related

- [large object descriptor was not opened for writing](./large-object-descriptor-was-not-opened-for-writing.md)
- [must be owner of large object](./must-be-owner-of-large-object.md)
