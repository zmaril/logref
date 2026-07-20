---
message: "cannot swap toast by links for mapped relation \"%s\""
slug: cannot-swap-toast-by-links-for-mapped-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1638"
reproduced: false
---

# `cannot swap toast by links for mapped relation "%s"`

## What it means

An internal guard fired during a relation swap: the code tried to exchange TOAST tables by relfilenode link for a mapped catalog relation. Mapped relations track their storage through the relation map, so a link-based TOAST swap does not apply.

## When it happens

It is reached from the TOAST-swap path when rebuilding a mapped catalog with `CLUSTER` or `VACUUM FULL`. It reflects an internal inconsistency, not a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, the relation involved, and the server log, then report it. It signals a bug or catalog inconsistency in the swap code.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot swap toast by links for mapped relation "pg_class"
```

## Related

- [cannot swap mapped relation with non-mapped relation](./cannot-swap-mapped-relation-with-non-mapped-relation.md)
- [cannot swap toast files by content when there's only one](./cannot-swap-toast-files-by-content-when-there-s-only-one.md)
