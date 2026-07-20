---
message: "Did not find any settings for role \"%s\" and database \"%s\"."
slug: did-not-find-any-settings-for-role-and-database
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:3962"
reproduced: false
---

# `Did not find any settings for role "%s" and database "%s".`

## What it means

A psql `\drds` command filtered to a role and a database found no settings for that pair. The placeholders are the role and database names. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\drds role database` finds no `ALTER ROLE ... IN DATABASE ... SET` overrides for that combination.

## How to fix

Nothing is wrong. If you expected a per-role-in-database override, add it with `ALTER ROLE rolename IN DATABASE dbname SET param = value`, and confirm both names.

## Example

*Illustrative* — no settings for the role/database pair.

```text
\drds app mydb
-- Did not find any settings for role "app" and database "mydb".
```

## Related

- [Did not find any settings for role](./did-not-find-any-settings-for-role.md)
- [Did not find any settings](./did-not-find-any-settings.md)
