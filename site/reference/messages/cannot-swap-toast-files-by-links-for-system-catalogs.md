---
message: "cannot swap toast files by links for system catalogs"
slug: cannot-swap-toast-files-by-links-for-system-catalogs
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1835"
reproduced: false
---

# `cannot swap toast files by links for system catalogs`

## What it means

An internal guard fired during a relation swap: the code tried to swap TOAST tables by relfilenode link for a system catalog. System catalogs need their TOAST storage handled by content, so a link-based swap does not apply.

## When it happens

It is reached from the TOAST-swap path when rebuilding a system catalog. It reflects an internal inconsistency, not a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, the catalog involved, and the server log, then report it. It signals a bug or catalog inconsistency in the swap code.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot swap toast files by links for system catalogs
```

## Related

- [cannot swap toast files by content when there's only one](./cannot-swap-toast-files-by-content-when-there-s-only-one.md)
- [cannot swap mapped relation with non-mapped relation](./cannot-swap-mapped-relation-with-non-mapped-relation.md)
