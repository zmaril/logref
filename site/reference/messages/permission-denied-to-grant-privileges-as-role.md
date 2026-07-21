---
message: "permission denied to grant privileges as role \"%s\""
slug: permission-denied-to-grant-privileges-as-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/user.c:2260"
  - "postgres/src/backend/commands/user.c:2269"
reproduced: false
---

# `permission denied to grant privileges as role "%s"`

## What it means

A `GRANT ... GRANTED BY` (or an implicit grantor) named a role as the grantor that the current user is not entitled to act as. The placeholder is that role. You can only grant privileges on behalf of a role whose privileges you legitimately hold.

## When it happens

It arises when using `GRANTED BY role` where the session role does not have the `SET ROLE` / membership rights over that role, or otherwise lacks standing to issue grants in its name.

## How to fix

Grant as a role you are actually a member of and permitted to act as, or omit `GRANTED BY` so the grantor defaults to your current role. To grant on behalf of another role, first obtain the needed membership (`WITH SET`/admin option) over it.

## Example

*Illustrative* — granting on behalf of a role you cannot act as.

```text
ERROR:  permission denied to grant privileges as role "owner"
```

## Related

- [permission denied to grant role "%s"](./permission-denied-to-grant-role.md)
- [permission denied to revoke role "%s"](./permission-denied-to-revoke-role.md)
