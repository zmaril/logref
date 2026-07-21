---
message: "root page %u of index \"%s\" has level %u, expected %u"
slug: root-page-of-index-has-level-expected
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtpage.c:558"
  - "postgres/src/backend/access/nbtree/nbtpage.c:641"
reproduced: false
---

# `root page %u of index "%s" has level %u, expected %u`

## What it means

A structural check on an index found the root page reporting a tree level different from what the index metadata says it should be. The placeholders are the root page number, index name, actual level, and expected level. It indicates index corruption.

## When it happens

It surfaces during index verification (for example `amcheck`) or an internal traversal that validates the B-tree's height against its metapage.

## How to fix

Treat the index as corrupt: `REINDEX` it to rebuild from the table data. Investigate the underlying cause (storage faults, an unclean crash, or a bug) and run `amcheck` more broadly to find other damaged indexes.

## Example

*Illustrative* — an index root page at an unexpected level.

```text
ERROR:  root page 3 of index "orders_pkey" has level 2, expected 1
```

## Related

- [out of overflow pages in hash index "%s"](./out-of-overflow-pages-in-hash-index.md)
- [some but not all node labels are null in SPGiST inner tuple](./some-but-not-all-node-labels-are-null-in-spgist-inner-tuple.md)
