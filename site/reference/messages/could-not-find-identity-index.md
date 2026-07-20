---
message: "could not find identity index"
slug: could-not-find-identity-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:3096"
reproduced: false
---

# `could not find identity index`

## What it means

A `REPACK` operation could not find the identity index it needs to reorder the table around. This is an internal guard reached after the command expected such an index to exist.

## When it happens

It fires during a repack when the index that determines row ordering cannot be located. Reaching it points at an internal problem or a catalog inconsistency rather than ordinary usage.

## How to fix

This is an internal error. Confirm the target index still exists and is valid, and check for concurrent DDL on the table. Note the table and index and report a reproducible case if the objects are intact.

## Example

*Illustrative* — the identity index missing during repack.

```text
ERROR:  could not find identity index
```

## Related

- [could not find index matching at the new relation](./could-not-find-index-matching-at-the-new-relation.md)
- [could not find equality strategy for index operator family for type](./could-not-find-equality-strategy-for-index-operator-family-for-type.md)
