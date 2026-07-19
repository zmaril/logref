---
message: "permission denied to alter role"
slug: permission-denied-to-alter-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/user.c:764"
  - "postgres/src/backend/commands/user.c:770"
  - "postgres/src/backend/commands/user.c:786"
  - "postgres/src/backend/commands/user.c:794"
  - "postgres/src/backend/commands/user.c:808"
  - "postgres/src/backend/commands/user.c:814"
  - "postgres/src/backend/commands/user.c:820"
  - "postgres/src/backend/commands/user.c:829"
  - "postgres/src/backend/commands/user.c:874"
  - "postgres/src/backend/commands/user.c:1037"
  - "postgres/src/backend/commands/user.c:1048"
reproduced: false
---

# `permission denied to alter role`

## What it means

A role tried to `ALTER ROLE` in a way it is not allowed to. Changing role attributes — especially privileged ones like `SUPERUSER`, `CREATEROLE`, `CREATEDB`, `REPLICATION`, or `BYPASSRLS`, or altering a role you do not have rights over — requires appropriate privileges.

## When it happens

A non-superuser altering another role without `CREATEROLE` (or without the newer `ADMIN`/membership rights), trying to grant itself or others privileged attributes, or attempting a change reserved for superusers. The rules tightened in recent versions around what `CREATEROLE` can confer.

## How to fix

Perform the change as a role with sufficient rights — a superuser, or a role with `CREATEROLE` and the necessary membership/admin over the target. Note that `CREATEROLE` cannot grant attributes it lacks (for example it cannot make a role `SUPERUSER`). Grant the minimum needed rather than escalating to superuser where possible.

## Example

*Illustrative* — a non-privileged role altering another.

```sql
ALTER ROLE admin CREATEDB;   -- run by an ordinary role
```

Produces:

```text
ERROR:  permission denied to alter role
```

## Related

- [role %s does not exist](./role-does-not-exist.md)
- [role %s is a member of role %s](./role-is-a-member-of-role.md)
