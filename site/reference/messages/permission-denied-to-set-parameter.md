---
message: "permission denied to set parameter \"%s\""
slug: permission-denied-to-set-parameter
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:3448"
  - "postgres/src/backend/utils/misc/guc.c:3510"
  - "postgres/src/backend/utils/misc/guc.c:4567"
  - "postgres/src/backend/utils/misc/guc.c:6632"
reproduced: false
---

# `permission denied to set parameter "%s"`

## What it means

A role tried to change a configuration parameter it is not allowed to set. The placeholder names the parameter. Many GUCs are `SUPERUSER`-only or require a specific privilege (granted via `GRANT ... ON PARAMETER`), so a role without it cannot change them even within its own session.

## When it happens

A non-superuser runs `SET`, `ALTER ROLE ... SET`, `ALTER DATABASE ... SET`, or `ALTER SYSTEM` for a restricted parameter without having been granted `SET`/`ALTER SYSTEM` privilege on it.

## How to fix

Have a superuser make the change, or grant the specific privilege: `GRANT SET ON PARAMETER <name> TO <role>` (or `ALTER SYSTEM` privilege) lets the role set it thereafter. Confirm the parameter's context with `pg_settings` — some are `PGC_POSTMASTER` and cannot be set at runtime by anyone.

## Example

*Illustrative* — a non-superuser setting a restricted GUC.

```sql
SET session_preload_libraries = 'x';  -- permission denied to set parameter
```

## Related

- [parameter requires a Boolean value](./parameter-requires-a-boolean-value.md)
- [must be superuser to use pageinspect functions](./must-be-superuser-to-use-pageinspect-functions.md)
