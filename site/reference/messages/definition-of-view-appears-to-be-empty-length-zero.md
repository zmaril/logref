---
message: "definition of view \"%s\" appears to be empty (length zero)"
slug: definition-of-view-appears-to-be-empty-length-zero
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:16985"
reproduced: false
---

# `definition of view "%s" appears to be empty (length zero)`

## What it means

During a dump, `pg_dump` retrieved the stored definition of a view and got an empty string. A zero-length definition cannot be turned back into a `CREATE VIEW`, so the dump would be incomplete.

## When it happens

It fires in `pg_dump` while dumping a view, when `pg_get_viewdef` returns empty — usually a server/version mismatch, insufficient privileges to read the definition, or catalog corruption.

## How to fix

Check that `pg_dump` is at least as new as the server and that the role can read the view definition. Try `SELECT pg_get_viewdef('viewname'::regclass)` directly; if it too is empty, investigate catalog integrity on the source.

## Example

*Illustrative* — an empty view definition during dump.

```text
pg_dump: error: definition of view "v" appears to be empty (length zero)
```

## Related

- [definition of property graph appears to be empty (length zero)](./definition-of-property-graph-appears-to-be-empty-length-zero.md)
- [did not find magic string in file header](./did-not-find-magic-string-in-file-header.md)
