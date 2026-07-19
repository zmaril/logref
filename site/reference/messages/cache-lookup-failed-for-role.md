---
message: "cache lookup failed for role %u"
slug: cache-lookup-failed-for-role
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/schemacmds.c:85"
  - "postgres/src/backend/commands/user.c:1947"
  - "postgres/src/backend/utils/adt/acl.c:5700"
  - "postgres/src/backend/utils/adt/acl.c:5706"
reproduced: false
---

# `cache lookup failed for role %u`

## What it means

Internal error. Code looked up a role catalog row (`pg_authid`/`pg_roles`) by OID and found nothing. The placeholder is the OID. A missing row for an OID in active use points to a concurrent `DROP ROLE` or catalog inconsistency.

## When it happens

Typically a concurrent `DROP ROLE` while an operation references that role (as owner, grantee, or in a session); otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If concurrent DDL was in flight, retry. If it recurs, inspect ownership/privilege dependencies on the missing role OID; a persistently missing row indicates corruption warranting investigation.

## Example

*Illustrative* — a concurrently dropped role.

```text
ERROR:  cache lookup failed for role 16384
```

## Related

- [cache lookup failed for namespace](./cache-lookup-failed-for-namespace.md)
- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)
