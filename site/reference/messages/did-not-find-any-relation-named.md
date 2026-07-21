---
message: "Did not find any relation named \"%s\"."
slug: did-not-find-any-relation-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:1491"
reproduced: false
---

# `Did not find any relation named "%s".`

## What it means

A psql describe command (`\d name`) matched no relation. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\d pattern` finds no table, view, index, sequence, or similar relation whose name matches, because none exists or the pattern does not match the search path.

## How to fix

List everything with a bare `\d`, check the spelling and any wildcards, and confirm the object's schema is on your search path. Schema-qualify the pattern if needed (`\d schema.name`).

## Example

*Illustrative* — a pattern matching nothing.

```text
\d nosuch
-- Did not find any relation named "nosuch".
```

## Related

- [Did not find any relations named](./did-not-find-any-relations-named.md)
- [Did not find any relation with OID](./did-not-find-any-relation-with-oid.md)
