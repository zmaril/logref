---
message: "role \"%s\" does not exist, skipping"
slug: role-does-not-exist-skipping
passthrough: false
api: [elog, ereport]
level: [NOTICE]
call_sites:
  - "postgres/src/backend/commands/foreigncmds.c:1449"
  - "postgres/src/backend/commands/user.c:1146"
reproduced: false
---

# `role "%s" does not exist, skipping`

## What it means

A `DROP ROLE ... IF EXISTS` (or an equivalent conditional drop) named a role that does not exist, so the server skipped it instead of raising an error.

## When it happens

It is issued at NOTICE when `IF EXISTS` is used and the named role is absent — the command succeeds and simply does nothing for that role.

## Is this a problem?

This is informational and means the drop was a no-op. If you expected the role to exist, check the spelling and that it was not already removed; otherwise no action is needed.

## Example

*Illustrative* — dropping a role that is not there.

```sql
DROP ROLE IF EXISTS reporting;  -- NOTICE:  role "reporting" does not exist, skipping
```

## Related

- [access to library is not allowed](./access-to-library-is-not-allowed.md)
- [absolute path not allowed](./absolute-path-not-allowed.md)
