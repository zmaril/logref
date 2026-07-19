---
message: "unrecognized dependency type '%c' for %s"
slug: unrecognized-dependency-type-for
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/dependency.c:820"
  - "postgres/src/backend/catalog/dependency.c:958"
reproduced: false
---

# `unrecognized dependency type '%c' for %s`

## What it means

Internal error in `pg_dump`. While ordering objects for the dump, the archiver met a dependency-type marker it does not recognize for a given object.

## When it happens

It fires during `pg_dump`/`pg_restore` dependency sorting when a dependency record carries an unexpected type code. A dump of a healthy database does not normally reach it.

## How to fix

This is a guard in the dump's dependency handling. Confirm the tool version matches (or is newer than) the server; if a routine dump reaches it, capture the object and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized dependency marker.

```text
ERROR:  unrecognized dependency type 'z' for TABLE orders
```

## Related

- [unrecognized dependency type: %d](./unrecognized-dependency-type.md)
- [archive items not in correct section order](./archive-items-not-in-correct-section-order.md)
