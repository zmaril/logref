---
message: "could not find equality strategy for index operator family %u for type %u"
slug: could-not-find-equality-strategy-for-index-operator-family-for-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:3122"
reproduced: false
---

# `could not find equality strategy for index operator family %u for type %u`

## What it means

A `REPACK` operation needed the equality strategy of an index operator family for a type and could not find one. The `%u` values give the operator family and type OIDs. This is an internal guard.

## When it happens

It fires while repacking a table around an index when the index's operator family lacks an equality operator for the column type. Standard index types provide one, so reaching it points at an unusual operator-family definition.

## How to fix

This is an internal error. If a custom operator class or family is involved, confirm it defines an equality operator for the type. Note the index and type and report a reproducible case if the definitions are complete.

## Example

*Illustrative* — a missing equality strategy during repack.

```text
ERROR:  could not find equality strategy for index operator family 1976 for type 23
```

## Related

- [could not find identity index](./could-not-find-identity-index.md)
- [could not find index matching at the new relation](./could-not-find-index-matching-at-the-new-relation.md)
