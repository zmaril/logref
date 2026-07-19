---
message: "index \"%s\" contains unexpected zero page at block %u"
slug: index-contains-unexpected-zero-page-at-block
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_gin.c:676"
  - "postgres/src/backend/access/gist/gistutil.c:796"
  - "postgres/src/backend/access/hash/hashutil.c:221"
  - "postgres/src/backend/access/nbtree/nbtpage.c:793"
reproduced: false
---

# `index "%s" contains unexpected zero page at block %u`

## What it means

An index-checking routine (here `amcheck` for GIN) found an all-zero page where a valid index page was expected. The placeholders are the index name and the block number. A zeroed page in the middle of an index is a corruption signature — either never written or wiped.

## When it happens

Running `amcheck` verification on an index, or an index scan encountering a page that was zeroed by an interrupted write, storage failure, or filesystem-level corruption.

## How to fix

Treat the named index as corrupt. Rebuild it with `REINDEX INDEX` (or `REINDEX INDEX CONCURRENTLY`), which recreates it from the table data. Investigate the underlying cause — storage faults, an unclean shutdown, or bad hardware — since a zero page means data was lost or never persisted.

## Example

*Illustrative* — amcheck finding a zero page.

```text
ERROR:  index "t_idx" contains unexpected zero page at block 42
```

## Related

- [fell off the end of index](./fell-off-the-end-of-index.md)
- [invalid ItemId](./invalid-itemid.md)
