---
message: "could not find a feasible split point for index \"%s\""
slug: could-not-find-a-feasible-split-point-for-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtsplitloc.c:261"
reproduced: false
---

# `could not find a feasible split point for index "%s"`

## What it means

The b-tree code could not choose a place to split a full index page. The `%s` names the index. This is an internal invariant: a splittable page should always yield a legal split point.

## When it happens

It fires during a b-tree page split on insertion. Reaching it points at an internal problem or index corruption rather than anything in the SQL.

## How to fix

This is an internal error. Suspect index corruption: run `amcheck`'s `bt_index_check` on the named index, and `REINDEX` it if a problem is confirmed. Report a reproducible case if the index checks out clean.

## Example

*Illustrative* — a page split with no legal split point.

```text
ERROR:  could not find a feasible split point for index "my_idx"
```

## Related

- [could not find left sibling of block in index](./could-not-find-left-sibling-of-block-in-index.md)
- [could not create unique index](./could-not-create-unique-index.md)
