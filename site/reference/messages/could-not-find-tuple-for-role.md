---
message: "could not find tuple for role %u"
slug: could-not-find-tuple-for-role
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/user.c:1292"
reproduced: false
---

# `could not find tuple for role %u`

## What it means

Role-management code looked up a role's `pg_authid` row by its identifier and did not find it. It needs that row to read or change the role's attributes.

## When it happens

It fires during `CREATE`/`ALTER`/`DROP ROLE` and related grants, when a role that was present a moment earlier is gone — typically because another session dropped it concurrently.

## How to fix

This is an internal guard reached on a concurrent change. Confirm the role still exists (`\du` in psql) and retry, and serialize role changes if multiple sessions manage roles at once. On stable definitions, capture the role OID and report a reproducible case.

## Example

*Illustrative* — a role that vanished mid-operation.

```text
ERROR:  could not find tuple for role 16385
```

## Related

- [could not find tuple for role membership](./could-not-find-tuple-for-role-membership.md)
- [could not find tuple for pg_auth_members entry](./could-not-find-tuple-for-pg-auth-members-entry.md)
