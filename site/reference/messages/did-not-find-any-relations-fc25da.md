---
message: "Did not find any ??? relations."
slug: did-not-find-any-relations-fc25da
passthrough: false
api: [pg_log_error_internal]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4297"
reproduced: false
---

# `Did not find any ??? relations.`

## What it means

An internal psql describe fallback for a relation listing that matched nothing, where the relation-kind label was not filled in, so psql printed `???` in place of the kind. This is psql reporting an empty result, not a server error.

## When it happens

It fires from psql's generic relation-describe path when a listing matches no objects and reaches the fallback that lacks a specific kind name.

## How to fix

Treat it as an ordinary empty result: check the search path and pattern, and list with the appropriate bare `\d` command. The `???` is just a missing kind label.

## Example

*Illustrative* — the generic empty-listing fallback.

```text
-- Did not find any ??? relations.
```

## Related

- [Did not find any ??? named](./did-not-find-any-named.md)
- [Did not find any relations named](./did-not-find-any-relations-named.md)
