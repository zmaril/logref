---
message: "creation of new role failed: %s"
slug: creation-of-new-role-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/scripts/createuser.c:402"
reproduced: false
---

# `creation of new role failed: %s`

## What it means

The `createuser` command-line tool could not create the role you asked for. The trailing text is the server's error explaining why.

## When it happens

It fires when `createuser` runs its `CREATE ROLE` against the server and the server refuses — for example the role already exists, or the connecting user lacks the privilege to create roles.

## How to fix

Read the trailing server error. `role already exists` means to pick a different name or drop the existing role first; a permission error means you need to connect as a role with `CREATEROLE` or superuser rights. Correct the cause and rerun.

## Example

*Illustrative* — the role already existed.

```text
createuser: error: creation of new role failed: ERROR:  role "app" already exists
```

## Related

- [database creation failed](./database-creation-failed.md)
- [current user cannot be renamed](./current-user-cannot-be-renamed.md)
