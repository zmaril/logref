---
message: "cannot verify that tuples from index \"%s\" can each be found by an independent index search"
slug: cannot-verify-that-tuples-from-index-can-each-be-found-by-an-independent-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:483"
reproduced: false
---

# `cannot verify that tuples from index "%s" can each be found by an independent index search`

## What it means

The amcheck extension was asked to run a cross-check that confirms each heap tuple is reachable from the index, but the index or its options do not support that verification. The requested check cannot be performed on this index.

## When it happens

It occurs when `bt_index_parent_check(... heapallindexed => true)` or a similar amcheck call runs against an index whose properties do not allow the independent-search cross-check.

## How to fix

Run amcheck without the unsupported cross-check option, or use it on a B-tree index that supports it. Consult the amcheck documentation for which options apply to which index types.

## Example

*Illustrative* — an unsupported amcheck cross-check.

```text
ERROR:  cannot verify that tuples from index "t_idx" can each be found by an independent index search
```

## Related

- [child high key is greater than rightmost pivot key on target level in index](./child-high-key-is-greater-than-rightmost-pivot-key-on-target-level-in-index.md)
- [cannot validate operator family without ordered data](./cannot-validate-operator-family-without-ordered-data.md)
