---
message: "could not find a legal dump ordering for memberships in role \"%s\""
slug: could-not-find-a-legal-dump-ordering-for-memberships-in-role
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dumpall.c:1142"
reproduced: false
---

# `could not find a legal dump ordering for memberships in role "%s"`

## What it means

`pg_dumpall` could not order the role-membership grants for a role into a sequence it can safely restore. The `%s` names the role. A cycle in the grant-with-admin structure left no valid order.

## When it happens

It happens during `pg_dumpall` (globals dump) when role memberships form a dependency cycle through `WITH ADMIN OPTION` grants that cannot be linearized.

## How to fix

Break the cycle in the role-membership grants before dumping. Review the `GRANT role TO role WITH ADMIN OPTION` structure for the named role and remove the circular grant, then rerun `pg_dumpall`.

## Example

*Illustrative* — a cyclic membership grant blocking the dump.

```text
pg_dumpall: error: could not find a legal dump ordering for memberships in role "team_lead"
```

## Related

- [could not find parent extension for](./could-not-find-parent-extension-for.md)
- [could not determine the number of users](./could-not-determine-the-number-of-users.md)
