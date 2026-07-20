---
message: "database \"%s\" is a system database"
slug: database-is-a-system-database
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_RESERVED_NAME
    code: "42939"
call_sites:
  - "postgres/src/backend/utils/adt/ddlutils.c:703"
reproduced: false
---

# `database "%s" is a system database`

## What it means

An operation that is not allowed on the built-in system databases was attempted on one of them. The placeholder is the database name. Databases such as `template0`, `template1`, and `postgres` have protections against certain changes. The server reports it as a reserved name.

## When it happens

It happens when you try to perform a restricted operation — for example certain drops or alterations — on a database the system reserves.

## How to fix

Do not target the system databases for this operation. Use a user-created database instead. If you were trying to reset a template, follow the documented procedure for template databases rather than operating on them directly.

## Example

*Illustrative* — a restricted operation on a system database.

```text
ERROR:  database "template0" is a system database
```

## Related

- [database is being used by prepared transactions](./database-is-being-used-by-prepared-transactions.md)
- [current user cannot be renamed](./current-user-cannot-be-renamed.md)
