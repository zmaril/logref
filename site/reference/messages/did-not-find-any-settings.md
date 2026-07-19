---
message: "Did not find any settings."
slug: did-not-find-any-settings
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:3968"
reproduced: false
---

# `Did not find any settings.`

## What it means

A psql `\drds` command found no per-role or per-database settings to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\drds` runs and no `ALTER ROLE ... SET` or `ALTER DATABASE ... SET` overrides exist.

## How to fix

Nothing is wrong. If you expected overrides, set them with `ALTER ROLE ... SET` or `ALTER DATABASE ... SET`, or narrow the query to a specific role or database.

## Example

*Illustrative* — no role/database settings.

```text
\drds
-- Did not find any settings.
```

## Related

- [Did not find any settings for role](./did-not-find-any-settings-for-role.md)
- [Did not find any settings for role and database](./did-not-find-any-settings-for-role-and-database.md)
