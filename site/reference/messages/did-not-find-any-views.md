---
message: "Did not find any views."
slug: did-not-find-any-views
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4287"
reproduced: false
---

# `Did not find any views.`

## What it means

A psql `\dv` command found no views to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dv` runs where no views are visible on the search path.

## How to fix

Nothing is wrong. If you expected views, check the schema and search path, and confirm they were created with `CREATE VIEW`.

## Example

*Illustrative* — no views to show.

```text
\dv
-- Did not find any views.
```

## Related

- [Did not find any views named](./did-not-find-any-views-named.md)
- [Did not find any materialized views](./did-not-find-any-materialized-views.md)
