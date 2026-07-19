---
message: "fell off the end of index \"%s\""
slug: fell-off-the-end-of-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtinsert.c:756"
  - "postgres/src/backend/access/nbtree/nbtinsert.c:1077"
  - "postgres/src/backend/access/nbtree/nbtsearch.c:318"
  - "postgres/src/backend/access/nbtree/nbtsearch.c:2040"
  - "postgres/src/backend/access/nbtree/nbtsearch.c:2130"
reproduced: false
---

# `fell off the end of index "%s"`

## What it means

Internal error. A btree traversal walked past the last page of the index without finding the expected stopping point. The placeholder is the index name. It is a structural consistency check; reaching the end unexpectedly means the index's page links are not as the algorithm requires.

## When it happens

It should not occur for a healthy index. Reaching it usually signals index corruption — broken sibling/child page pointers — rather than anything in your query.

## How to fix

Suspect index corruption on the named index. Verify it with `amcheck` (`bt_index_check`/`bt_index_parent_check`), and rebuild it with `REINDEX INDEX`. If corruption recurs, investigate storage and memory health, since it points to damaged on-disk structure.

## Example

*Illustrative* — a corrupt btree walked off its end.

```text
ERROR:  fell off the end of index "t_pkey"
```

## Related

- [index contains unexpected zero page at block](./index-contains-unexpected-zero-page-at-block.md)
- [invalid ItemId](./invalid-itemid.md)
