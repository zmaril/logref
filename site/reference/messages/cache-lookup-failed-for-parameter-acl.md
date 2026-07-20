---
message: "cache lookup failed for parameter ACL %u"
slug: cache-lookup-failed-for-parameter-acl
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:2472"
  - "postgres/src/backend/catalog/objectaddress.c:4024"
  - "postgres/src/backend/catalog/objectaddress.c:6128"
reproduced: false
---

# `cache lookup failed for parameter ACL %u`

## What it means

Internal error. The catalog row recording a configuration parameter's access-control list (`pg_parameter_acl`) could not be found by OID. The placeholder is the OID. This catalog holds `GRANT`s on GUC parameters; code expected an entry that was not present.

## When it happens

A concurrent change that removed the parameter ACL entry (for example revoking the last grant), or catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent `GRANT`/`REVOKE ... ON PARAMETER`, retry. If it recurs for one OID, inspect `pg_parameter_acl`; a dangling reference indicates corruption. Report reproducible cases.

## Example

*Illustrative* — a parameter ACL row not found.

```text
ERROR:  cache lookup failed for parameter ACL 16600
```

## Related

- [permission denied to set parameter](./permission-denied-to-set-parameter.md)
- [cache lookup failed for object of catalog](./cache-lookup-failed-for-object-of-catalog.md)
