---
message: "role \"%s\" is a member of role \"%s\""
slug: role-is-a-member-of-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_GRANT_OPERATION
call_sites:
  - "postgres/src/backend/commands/user.c:1758"
reproduced: true
---

# `role "%s" is a member of role "%s"`

## What it means

A role-membership grant would have created a cycle. Postgres role membership forms an inheritance graph, and cycles are disallowed — role A cannot be granted membership in role B if B is already (directly or indirectly) a member of A. The placeholders name the two roles on the cycle.

## When it happens

`GRANT b TO a` when `a` is already a member of `b`, or any longer chain that would close a loop. It surfaces while wiring up nested group roles and permission hierarchies.

## How to fix

Rework the hierarchy so membership flows one way. Inspect the current graph with `\du` in `psql` or by querying `pg_auth_members`, and remove the grant that would close the loop. If you intended a shared privilege set, grant both roles membership in a common parent role instead of linking them to each other.

## Example

*Reproduced* — the ACL/role scenario builds a membership cycle (`07_acl.sql`).

```sql
GRANT groupa TO groupb;
GRANT groupb TO groupa;
```

Produces:

```text
ERROR:  role "groupb" is a member of role "groupa"
```

## Related

- [permission denied for database](./permission-denied-for-database.md)
