---
message: "default privileges cannot be set for columns"
slug: default-privileges-cannot-be-set-for-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_GRANT_OPERATION
    code: "0LP01"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:1058"
reproduced: false
---

# `default privileges cannot be set for columns`

## What it means

`ALTER DEFAULT PRIVILEGES` tried to grant or revoke a column-level privilege. Default privileges apply to whole object types (tables, sequences, functions, and so on), never to individual columns.

## When it happens

It fires from `ALTER DEFAULT PRIVILEGES ... GRANT`/`REVOKE` when the privilege list targets specific columns.

## How to fix

Grant the whole-object privilege in the default rule (for example `GRANT SELECT ON TABLES`), and manage column-level privileges directly on each table with `GRANT SELECT (col) ON tablename`. There is no default-privileges mechanism for columns.

## Example

*Illustrative* — column privileges in a default rule.

```sql
ALTER DEFAULT PRIVILEGES GRANT SELECT (id) ON TABLES TO app;
-- default privileges cannot be set for columns
```

## Related

- [default ACL for user in schema on ... does not exist](./default-acl-for-user-in-schema-on-does-not-exist.md)
- [default ACL for user on ... does not exist](./default-acl-for-user-on-does-not-exist.md)
