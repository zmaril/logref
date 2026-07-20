---
message: "Did not find any relations named \"%s\"."
slug: did-not-find-any-relations-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4251"
reproduced: false
---

# `Did not find any relations named "%s".`

## What it means

A psql describe command (`\dt`, `\d`, or similar) with a name pattern matched no relations. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when a relation-listing pattern matches nothing on the search path, because no matching relation exists.

## How to fix

List all relations with a bare `\d`, check the pattern and search path, and schema-qualify the pattern if the object lives in another schema.

## Example

*Illustrative* — a pattern matching no relations.

```text
\dt app_*
-- Did not find any relations named "app_*".
```

## Related

- [Did not find any relation named](./did-not-find-any-relation-named.md)
- [Did not find any tables named](./did-not-find-any-tables-named.md)
