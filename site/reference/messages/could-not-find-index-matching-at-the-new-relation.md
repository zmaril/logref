---
message: "could not find index matching \"%s\" at the new relation"
slug: could-not-find-index-matching-at-the-new-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:3233"
reproduced: false
---

# `could not find index matching "%s" at the new relation`

## What it means

A `REPACK` operation could not find an index on the rebuilt relation matching the one on the original. The `%s` names the index. This is an internal guard in the repack's index-remapping step.

## When it happens

It fires while repacking a table when the corresponding index on the new relation copy cannot be matched to the original. Reaching it points at an internal problem rather than ordinary usage.

## How to fix

This is an internal error. Check for concurrent DDL on the table's indexes during the repack. Note the table and index and report a reproducible case if the objects are stable.

## Example

*Illustrative* — an index that cannot be matched after repack.

```text
ERROR:  could not find index matching "my_idx" at the new relation
```

## Related

- [could not find identity index](./could-not-find-identity-index.md)
- [could not find equality strategy for index operator family for type](./could-not-find-equality-strategy-for-index-operator-family-for-type.md)
