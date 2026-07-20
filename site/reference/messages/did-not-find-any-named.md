---
message: "Did not find any ??? named \"%s\"."
slug: did-not-find-any-named
passthrough: false
api: [pg_log_error_internal]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4275"
reproduced: false
---

# `Did not find any ??? named "%s".`

## What it means

An internal psql describe fallback. A relation-listing command matched nothing and the relation-kind label was not filled in, so psql printed a placeholder (`???`) where the object type would go. The placeholder is the name pattern.

## When it happens

It fires from psql's generic relation-describe path when no object matches a pattern and the code reached the fallback that lacks a specific kind name.

## How to fix

Treat it like any "did not find" notice: check the pattern and search path, and list all objects with the appropriate bare `\d` command. The `???` simply means psql had no specific label for the requested kind.

## Example

*Illustrative* — the generic fallback message.

```text
-- Did not find any ??? named "foo".
```

## Related

- [Did not find any ??? relations](./did-not-find-any-relations-fc25da.md)
- [Did not find any relation named](./did-not-find-any-relation-named.md)
