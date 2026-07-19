---
message: "unrecognized dependency type: %d"
slug: unrecognized-dependency-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_shdepend.c:1309"
  - "postgres/src/backend/catalog/pg_shdepend.c:1622"
reproduced: false
---

# `unrecognized dependency type: %d`

## What it means

Internal error. Dependency-tracking code met a dependency-type code (the byte classifying how one catalog object depends on another) that it does not recognize.

## When it happens

It fires while walking `pg_depend` during drop or alter processing when an entry carries an unexpected type. Normal catalogs do not produce it.

## How to fix

This is an internal guard over the dependency catalog. If routine DDL reaches it, the dependency records may be inconsistent; capture the objects and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized dependency type.

```text
ERROR:  unrecognized dependency type: 120
```

## Related

- [unrecognized dependency type '%c' for %s](./unrecognized-dependency-type-for.md)
- [unexpected object depending on column: %s](./unexpected-object-depending-on-column.md)
