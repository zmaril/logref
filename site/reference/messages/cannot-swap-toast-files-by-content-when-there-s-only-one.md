---
message: "cannot swap toast files by content when there's only one"
slug: cannot-swap-toast-files-by-content-when-there-s-only-one
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1808"
reproduced: false
---

# `cannot swap toast files by content when there's only one`

## What it means

An internal guard fired during a relation swap: the code was asked to swap TOAST tables by content, but only one of the two relations had a TOAST table. A content swap needs both sides to have one, so this state should not occur.

## When it happens

It is reached from the TOAST-swap path when rebuilding a table with `CLUSTER` or `VACUUM FULL`. It reflects an internal inconsistency, not a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, the relation names, and the server log, then report it. It points to a bug or catalog inconsistency in the swap code.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot swap toast files by content when there's only one
```

## Related

- [cannot swap toast by links for mapped relation](./cannot-swap-toast-by-links-for-mapped-relation.md)
- [cannot swap toast files by links for system catalogs](./cannot-swap-toast-files-by-links-for-system-catalogs.md)
