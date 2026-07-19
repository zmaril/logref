---
message: "database user \"%s\" is not the install user"
slug: database-user-is-not-the-install-user
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/check.c:1037"
reproduced: false
---

# `database user "%s" is not the install user`

## What it means

`pg_upgrade` found that the database superuser it connected as is not the user that owns the installation (the bootstrap superuser). The placeholder is the user name. `pg_upgrade` requires the install user so ownership and privileges transfer consistently.

## When it happens

It happens during `pg_upgrade` when the role it connects as differs from the cluster's original install superuser, or when extra superusers complicate the ownership picture.

## How to fix

Run `pg_upgrade` as the install user — the bootstrap superuser created by `initdb`, usually `postgres`. Connect with that role via the `--username` option. If additional superusers are the problem, follow `pg_upgrade`'s guidance on resolving them before upgrading.

## Example

*Illustrative* — upgrading as a non-install superuser.

```text
pg_upgrade: error: database user "admin" is not the install user
```

## Related

- [data type checks failed](./data-type-checks-failed.md)
- [data directory has wrong ownership](./data-directory-has-wrong-ownership.md)
