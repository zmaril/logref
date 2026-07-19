---
message: "could not find tuple for default ACL %u"
slug: could-not-find-tuple-for-default-acl
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:1451"
  - "postgres/src/backend/catalog/objectaddress.c:3889"
  - "postgres/src/backend/catalog/objectaddress.c:6009"
reproduced: false
---

# `could not find tuple for default ACL %u`

## What it means

Internal error. Code looked up a default-privileges entry in `pg_default_acl` by OID and found no row. The placeholder is the OID. `pg_default_acl` holds the `ALTER DEFAULT PRIVILEGES` settings; a referenced entry was expected and missing.

## When it happens

A concurrent change that removed the default-ACL entry, or catalog inconsistency. Not driven by ordinary data.

## How to fix

If it coincides with concurrent `ALTER DEFAULT PRIVILEGES`, retry. If it recurs for one OID, inspect `pg_default_acl`; a dangling reference indicates corruption. Report reproducible cases.

## Example

*Illustrative* — a default-ACL row not found.

```text
ERROR:  could not find tuple for default ACL 16740
```

## Related

- [could not find tuple for database](./could-not-find-tuple-for-database.md)
- [cache lookup failed for parameter ACL](./cache-lookup-failed-for-parameter-acl.md)
