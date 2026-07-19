---
message: "Did not find any materialized views named \"%s\"."
slug: did-not-find-any-materialized-views-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4263"
reproduced: false
---

# `Did not find any materialized views named "%s".`

## What it means

A psql `\dm` command with a name pattern matched no materialized view. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dm pattern` finds no materialized view whose name matches, because none exists or the pattern does not match.

## How to fix

List all materialized views with a bare `\dm`, and check the pattern and search path.

## Example

*Illustrative* — a pattern matching no materialized view.

```text
\dm sales_*
-- Did not find any materialized views named "sales_*".
```

## Related

- [Did not find any materialized views](./did-not-find-any-materialized-views.md)
- [Did not find any views named](./did-not-find-any-views-named.md)
