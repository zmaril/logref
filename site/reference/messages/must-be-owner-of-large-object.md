---
message: "must be owner of large object %u"
slug: must-be-owner-of-large-object
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2580"
  - "postgres/src/backend/libpq/be-fsstubs.c:332"
reproduced: false
---

# `must be owner of large object %u`

## What it means

An operation on a large object requires ownership of it, and the current role is not the owner. The placeholder is the large object's OID.

## When it happens

It arises from `ALTER LARGE OBJECT`, `lo_unlink`, or `COMMENT ON LARGE OBJECT` when the invoking role neither owns the large object nor has the needed superuser privilege.

## How to fix

Perform the operation as the large object's owner or a superuser, or have the owner run it. Ownership can be changed with `ALTER LARGE OBJECT oid OWNER TO role` by a suitably privileged role.

## Example

*Illustrative* — unlinking a large object you do not own.

```sql
SELECT lo_unlink(16385);  -- must be owner of large object 16385
```

## Related

- [invalid OID for large object](./invalid-oid-for-large-object-a856c1.md)
- [large object descriptor was not opened for writing](./large-object-descriptor-was-not-opened-for-writing.md)
