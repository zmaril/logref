---
message: "attempt to apply a mapping to unmapped relation %u"
slug: attempt-to-apply-a-mapping-to-unmapped-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relmapper.c:401"
reproduced: false
---

# `attempt to apply a mapping to unmapped relation %u`

## What it means

The relation-mapping subsystem was asked to apply a filenode mapping to a relation that is not in the mapped set (mapped relations are certain system catalogs), which should never happen — an internal consistency guard.

## When it happens

It is raised during operations that manipulate the relation map (such as some rewrite or upgrade paths) if a non-mapped relation reaches the mapping code, normally only through a bug.

## How to fix

This is an internal error rather than a user-fixable SQL condition. If it appears, it may indicate catalog trouble; capture the log, avoid further writes, and report it. Restoring from a known-good backup is the safe course if catalog integrity is in doubt.

## Example

*Illustrative* — a mapping applied to a non-mapped relation.

```text
ERROR:  attempt to apply a mapping to unmapped relation 16400
```

## Related

- [attempt to write bogus relation mapping](./attempt-to-write-bogus-relation-mapping.md)
- [accessexclusivelock required to add toast table](./accessexclusivelock-required-to-add-toast-table.md)
