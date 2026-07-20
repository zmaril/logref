---
message: "Did not find any materialized views."
slug: did-not-find-any-materialized-views
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4289"
reproduced: false
---

# `Did not find any materialized views.`

## What it means

A psql `\dm` command found no materialized views to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dm` runs where no materialized views are visible on the search path.

## How to fix

Nothing is wrong. If you expected some, check the schema and search path, and confirm the materialized views were created (`CREATE MATERIALIZED VIEW`).

## Example

*Illustrative* — no materialized views to show.

```text
\dm
-- Did not find any materialized views.
```

## Related

- [Did not find any materialized views named](./did-not-find-any-materialized-views-named.md)
- [Did not find any views](./did-not-find-any-views.md)
