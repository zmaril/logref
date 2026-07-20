---
message: "database creation failed: %s"
slug: database-creation-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/scripts/createdb.c:262"
reproduced: false
---

# `database creation failed: %s`

## What it means

The `createdb` command-line tool could not create the database you asked for. The trailing text is the server's error explaining why.

## When it happens

It fires when `createdb` runs its `CREATE DATABASE` and the server refuses — for example the database already exists, the name is invalid, or the connecting user lacks the `CREATEDB` privilege.

## How to fix

Read the trailing server error. `database already exists` means to pick a different name or drop the existing one; a permission error means you need a role with `CREATEDB` or superuser rights. Correct the cause and rerun.

## Example

*Illustrative* — the database already existed.

```text
createdb: error: database creation failed: ERROR:  database "sales" already exists
```

## Related

- [database removal failed](./database-removal-failed.md)
- [creation of new role failed](./creation-of-new-role-failed.md)
