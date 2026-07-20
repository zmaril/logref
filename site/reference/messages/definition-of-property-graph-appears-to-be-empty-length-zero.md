---
message: "definition of property graph \"%s\" appears to be empty (length zero)"
slug: definition-of-property-graph-appears-to-be-empty-length-zero
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:17143"
reproduced: false
---

# `definition of property graph "%s" appears to be empty (length zero)`

## What it means

During a dump, `pg_dump` retrieved the stored definition of a property graph and got an empty string. A zero-length definition means the catalog query returned nothing usable, so the object cannot be reproduced faithfully.

## When it happens

It fires in `pg_dump` while dumping a property graph, when the reconstructed definition comes back empty — typically a server/version mismatch, a permissions problem reading the catalog, or catalog damage.

## How to fix

Confirm the `pg_dump` version matches or exceeds the server version and that the dumping role can read the object's definition. If the definition is genuinely empty in the catalog, investigate catalog integrity on the source database.

## Example

*Illustrative* — an empty property-graph definition.

```text
pg_dump: error: definition of property graph "g" appears to be empty (length zero)
```

## Related

- [definition of view appears to be empty (length zero)](./definition-of-view-appears-to-be-empty-length-zero.md)
- [did not find magic string in file header](./did-not-find-magic-string-in-file-header.md)
