---
message: "cannot initialize non-empty hash index \"%s\""
slug: cannot-initialize-non-empty-hash-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/hash/hashpage.c:344"
reproduced: false
---

# `cannot initialize non-empty hash index "%s"`

## What it means

An internal guard in the hash-index access method fired: it tried to initialize the metapage of a hash index that already contains pages. Metapage initialization runs only on a brand-new, empty index, so a non-empty one is refused. The placeholder is the index name.

## When it happens

It is reached during hash-index build or reinitialization when the index unexpectedly already holds data. It reflects a coding issue or on-disk inconsistency rather than a routine user action.

## How to fix

There is no user-level fix. If it appears, the index may be in an inconsistent state: `REINDEX` it to rebuild from scratch. If the rebuild also fails or it recurs, capture the index and report it.

## Example

*Illustrative* — metapage init on a non-empty hash index.

```text
ERROR:  cannot initialize non-empty hash index "my_hash_idx"
```

## Related

- [cannot insert into frozen hashtable](./cannot-insert-into-frozen-hashtable.md)
- [cannot insert oversize tuple of size on internal page of index](./cannot-insert-oversized-tuple-of-size-on-internal-page-of-index.md)
