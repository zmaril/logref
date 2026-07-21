---
message: "child high key is greater than rightmost pivot key on target level in index \"%s\""
slug: child-high-key-is-greater-than-rightmost-pivot-key-on-target-level-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:2310"
reproduced: false
---

# `child high key is greater than rightmost pivot key on target level in index "%s"`

## What it means

The amcheck extension found a B-tree index whose internal structure is inconsistent: a child page's high key exceeds the rightmost pivot key on its target level. This ordering invariant is broken, which means the index is corrupt.

## When it happens

It is reported by `bt_index_check()` or `bt_index_parent_check()` while walking the index and comparing keys across levels.

## How to fix

Treat the index as corrupt. Rebuild it with `REINDEX INDEX`, and investigate the underlying cause such as storage faults or an operating-system collation change that reordered keys.

## Example

*Illustrative* — an amcheck B-tree ordering violation.

```text
ERROR:  child high key is greater than rightmost pivot key on target level in index "t_idx"
```

## Related

- [cannot verify that tuples from index can each be found by an independent index search](./cannot-verify-that-tuples-from-index-can-each-be-found-by-an-independent-index.md)
- [checksum verification failure during base backup](./checksum-verification-failure-during-base-backup.md)
