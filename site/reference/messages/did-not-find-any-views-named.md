---
message: "Did not find any views named \"%s\"."
slug: did-not-find-any-views-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4260"
reproduced: false
---

# `Did not find any views named "%s".`

## What it means

A psql `\dv` command with a name pattern matched no view. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dv pattern` finds no view whose name matches, because none exists or the pattern does not match.

## How to fix

List all views with a bare `\dv`, and check the pattern and search path.

## Example

*Illustrative* — a pattern matching no view.

```text
\dv rpt_*
-- Did not find any views named "rpt_*".
```

## Related

- [Did not find any views](./did-not-find-any-views.md)
- [Did not find any materialized views named](./did-not-find-any-materialized-views-named.md)
