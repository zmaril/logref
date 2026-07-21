---
message: "Did not find any foreign tables named \"%s\"."
slug: did-not-find-any-foreign-tables-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4269"
reproduced: false
---

# `Did not find any foreign tables named "%s".`

## What it means

A psql `\det` command with a name pattern matched no foreign table. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\det pattern` finds no foreign table whose name matches, because none exists or the pattern does not match.

## How to fix

List all foreign tables with a bare `\det`, check the pattern and search path, and confirm the foreign table exists with `CREATE FOREIGN TABLE`.

## Example

*Illustrative* — a pattern matching no foreign table.

```text
\det remote_*
-- Did not find any foreign tables named "remote_*".
```

## Related

- [Did not find any foreign tables](./did-not-find-any-foreign-tables.md)
- [Did not find any tables named](./did-not-find-any-tables-named.md)
