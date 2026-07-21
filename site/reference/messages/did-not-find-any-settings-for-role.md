---
message: "Did not find any settings for role \"%s\"."
slug: did-not-find-any-settings-for-role
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:3965"
reproduced: false
---

# `Did not find any settings for role "%s".`

## What it means

A psql `\drds` command filtered to a role found no settings for it. The placeholder is the role name. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\drds role` finds no `ALTER ROLE ... SET` overrides for that role.

## How to fix

Nothing is wrong. If you expected role-level settings, add them with `ALTER ROLE rolename SET param = value`, and confirm the role name.

## Example

*Illustrative* — no settings for a role.

```text
\drds app
-- Did not find any settings for role "app".
```

## Related

- [Did not find any settings](./did-not-find-any-settings.md)
- [Did not find any settings for role and database](./did-not-find-any-settings-for-role-and-database.md)
