---
message: "cache lookup failed for user mapping %u"
slug: cache-lookup-failed-for-user-mapping
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3843"
  - "postgres/src/backend/catalog/objectaddress.c:5957"
  - "postgres/src/backend/commands/foreigncmds.c:1368"
reproduced: false
---

# `cache lookup failed for user mapping %u`

## What it means

Internal error. A user mapping's catalog row (`pg_user_mapping`) could not be found by OID. The placeholder is the OID. User mappings tie a local role to credentials on a foreign server; code expected the mapping to exist.

## When it happens

A concurrent `DROP USER MAPPING`, or catalog inconsistency. Not caused by ordinary data.

## How to fix

If concurrent DDL removed the mapping, retry. If it recurs for one OID, inspect `pg_user_mapping`; a dangling reference indicates corruption. Report reproducible cases.

## Example

*Illustrative* — a user mapping dropped while referenced.

```text
ERROR:  cache lookup failed for user mapping 16810
```

## Related

- [cache lookup failed for foreign table](./cache-lookup-failed-for-foreign-table.md)
- [foreign-data wrapper does not exist](./foreign-data-wrapper-does-not-exist.md)
