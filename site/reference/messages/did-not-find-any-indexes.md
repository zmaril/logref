---
message: "Did not find any indexes."
slug: did-not-find-any-indexes
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4285"
reproduced: false
---

# `Did not find any indexes.`

## What it means

A psql `\di` command found no indexes to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\di` runs on a database (or search path) with no indexes visible.

## How to fix

Nothing is wrong. If you expected indexes, check your search path and schema, and remember system indexes are hidden unless you use `\diS`.

## Example

*Illustrative* — no indexes to show.

```text
\di
-- Did not find any indexes.
```

## Related

- [Did not find any indexes named](./did-not-find-any-indexes-named.md)
- [Did not find any relations named](./did-not-find-any-relations-named.md)
