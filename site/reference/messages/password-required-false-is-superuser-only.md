---
message: "password_required=false is superuser-only"
slug: password-required-false-is-superuser-only
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/contrib/postgres_fdw/option.c:195"
  - "postgres/src/backend/commands/alter.c:248"
  - "postgres/src/backend/commands/subscriptioncmds.c:742"
  - "postgres/src/backend/commands/subscriptioncmds.c:1708"
  - "postgres/src/backend/commands/subscriptioncmds.c:1783"
  - "postgres/src/backend/commands/subscriptioncmds.c:2883"
reproduced: true
---

# `password_required=false is superuser-only`

## What it means

A `postgres_fdw` user mapping tried to set `password_required 'false'`, and the current role is not a superuser. That option lets the foreign connection proceed without a password from the mapped user, which is a privilege-sensitive setting, so only superusers may set it.

## When it happens

Running `CREATE USER MAPPING` or `ALTER USER MAPPING` with `password_required 'false'` as a non-superuser.

## How to fix

Have a superuser create or alter the mapping, or leave `password_required` at its default (`true`) and supply a password in the mapping. The restriction exists because a passwordless mapping could let a non-superuser borrow the server process's own credentials.

## Example

*Reproduced* — captured from `reproducers/scenarios/65_contrib_fdw_dblink_crypto.sql`.

```sql
CREATE USER MAPPING FOR repro_fdw_ro SERVER repro_fp_ok OPTIONS (password_required 'false');
```

Produces:

```text
ERROR:  password_required=false is superuser-only
```

## Related

- [permission denied to create role](./permission-denied-to-create-role.md)
- [invalid option](./invalid-option.md)
