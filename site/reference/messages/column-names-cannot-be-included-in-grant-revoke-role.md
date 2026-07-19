---
message: "column names cannot be included in GRANT/REVOKE ROLE"
slug: column-names-cannot-be-included-in-grant-revoke-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_GRANT_OPERATION
    code: "0LP01"
call_sites:
  - "postgres/src/backend/commands/user.c:1567"
reproduced: false
---

# `column names cannot be included in GRANT/REVOKE ROLE`

## What it means

A `GRANT` or `REVOKE` that operates on a role membership included a column list. Column-level privileges apply only to tables and views, not to role grants, so a column list is invalid here.

## When it happens

It happens when `GRANT role_name (...)` or a similar role statement is written with parentheses that look like a column list.

## How to fix

Remove the column list from the role `GRANT`/`REVOKE`. Column privileges belong to `GRANT ... ON TABLE tab (cols) TO ...` statements instead.

## Example

*Illustrative* — a column list on a role grant.

```sql
GRANT admins (a) TO alice;
-- ERROR:  column names cannot be included in GRANT/REVOKE ROLE
```

## Related

- [column privileges are only valid for relations](./column-privileges-are-only-valid-for-relations.md)
- [column name specified more than once](./column-name-specified-more-than-once.md)
