---
message: "permission denied for large object %u"
slug: permission-denied-for-large-object
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/storage/large_object/inv_api.c:257"
  - "postgres/src/backend/storage/large_object/inv_api.c:269"
  - "postgres/src/backend/storage/large_object/inv_api.c:466"
  - "postgres/src/backend/storage/large_object/inv_api.c:575"
  - "postgres/src/backend/storage/large_object/inv_api.c:763"
reproduced: false
---

# `permission denied for large object %u`

## What it means

The current role lacks the privilege needed for a large-object operation. The placeholder is the large object's OID. Large objects have their own owner and `SELECT`/`UPDATE` privileges; reading or modifying one without them is refused.

## When it happens

Reading (`lo_read`, `lo_export`) or writing (`lo_write`, `lo_unlink`) a large object owned by another role, without having been granted the corresponding privilege, and without being a superuser.

## How to fix

Have the large object's owner grant access — `GRANT SELECT ON LARGE OBJECT <oid> TO role` for reads, `GRANT UPDATE` for writes — or perform the operation as the owner or a superuser. Note the `lo_compat_privileges` setting relaxes these checks if enabled.

## Example

*Illustrative* — reading another owner's large object.

```sql
SELECT lo_get(16452);
```

## Related

- [large object does not exist](./large-object-does-not-exist.md)
- [permission denied for sequence](./permission-denied-for-sequence.md)
