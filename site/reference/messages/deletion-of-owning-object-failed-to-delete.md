---
message: "deletion of owning object %s failed to delete %s"
slug: deletion-of-owning-object-failed-to-delete
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/dependency.c:778"
reproduced: false
---

# `deletion of owning object %s failed to delete %s`

## What it means

An internal dependency-tracking guard. When dropping an object, the code expected a dependent object to be removed along with it, but that dependent was still present afterward. The placeholders name the owning and dependent objects.

## When it happens

It fires during `DROP` processing when the recursive dependency walk does not remove everything it should, which points at a catalog inconsistency rather than ordinary usage.

## How to fix

This is not a routine user error. It suggests damaged `pg_depend` entries or a catalog bug. Capture the full statement and log context. Investigate catalog integrity; a reproducible case is worth reporting to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  deletion of owning object table t failed to delete default value ...
```

## Related

- [don't know how to set owner for object type](./don-t-know-how-to-set-owner-for-object-type.md)
- [does not require a toast table](./does-not-require-a-toast-table.md)
