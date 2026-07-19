---
message: "could not find tuple for large object %u"
slug: could-not-find-tuple-for-large-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:2333"
  - "postgres/src/backend/catalog/aclchk.c:4539"
reproduced: false
---

# `could not find tuple for large object %u`

## What it means

Internal error. A large object's metadata row could not be found in `pg_largeobject_metadata` by OID while checking or changing its privileges. The placeholder is the OID the lookup used.

## When it happens

A concurrent removal of the large object while a `GRANT`/`REVOKE` or ownership operation still referenced its OID, or catalog inconsistency.

## How to fix

If concurrent large-object DDL was running, retry. If it recurs, check `pg_largeobject_metadata` for the OID; a missing row points to catalog damage. Record and report a reproducible case.

## Example

*Illustrative* — a large object removed mid-grant.

```text
ERROR:  could not find tuple for large object 24576
```

## Related

- [could not find tuple for label property](./could-not-find-tuple-for-label-property.md)
- [could not open large object](./could-not-open-large-object.md)
