---
message: "AccessExclusiveLock required to add toast table."
slug: accessexclusivelock-required-to-add-toast-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/toasting.c:194"
reproduced: false
---

# `AccessExclusiveLock required to add toast table.`

## What it means

Internal code attempted to add a TOAST table to a relation without holding the `AccessExclusiveLock` that this structural change requires, and the assertion guarding that requirement failed.

## When it happens

It is raised on an internal code path that adds out-of-line (TOAST) storage to a table, if that path is reached without the exclusive lock the operation demands. It is an internal invariant, not a user command form.

## How to fix

This is an internal error rather than something to fix in SQL. It usually indicates a bug or an extension calling low-level routines incorrectly. Capture the statement and any extensions in use and report it; there is no user-level workaround.

## Example

*Illustrative* — the lock invariant failing while adding TOAST storage.

```text
ERROR:  AccessExclusiveLock required to add toast table.
```

## Related

- [already-planned subqueries not supported](./already-planned-subqueries-not-supported.md)
- [attempt to apply a mapping to unmapped relation](./attempt-to-apply-a-mapping-to-unmapped-relation.md)
