---
message: "out of overflow pages in hash index \"%s\""
slug: out-of-overflow-pages-in-hash-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/hash/hashovfl.c:283"
  - "postgres/src/backend/access/hash/hashpage.c:452"
reproduced: false
---

# `out of overflow pages in hash index "%s"`

## What it means

A hash index ran out of the overflow pages it uses to hold entries that do not fit in their primary bucket page. The index's internal addressing for overflow pages has no more room. The placeholder is the index name.

## When it happens

It is a rare limit reached by a very large or badly skewed hash index where many keys hash into the same buckets, exhausting the overflow-page address space.

## How to fix

Rebuild the index with `REINDEX`, which can relieve transient bloat. If the data is fundamentally too large or too skewed for a hash index, switch that column to a B-tree index, which does not have this overflow-page limit.

## Example

*Illustrative* — a hash index that has consumed its overflow-page space.

```text
ERROR:  out of overflow pages in hash index "orders_hash_idx"
```

## Related

- [root page %u of index "%s" has level %u, expected %u](./root-page-of-index-has-level-expected.md)
- [relation is not a bloom index](./relation-is-not-a-bloom-index.md)
