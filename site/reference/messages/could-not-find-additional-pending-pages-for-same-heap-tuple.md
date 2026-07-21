---
message: "could not find additional pending pages for same heap tuple"
slug: could-not-find-additional-pending-pages-for-same-heap-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gin/ginget.c:1814"
reproduced: false
---

# `could not find additional pending pages for same heap tuple`

## What it means

A GIN index scan expected more pending-list pages for a heap tuple and could not find them. This is an internal consistency check in the GIN pending-list scan.

## When it happens

It fires while scanning a GIN index's pending list. Reaching it points at an internal problem or index corruption rather than anything in the query.

## How to fix

This is an internal error. Suspect GIN index corruption: `REINDEX` the affected index. If the problem persists on a freshly built index, note the operation and report a reproducible case.

## Example

*Illustrative* — a GIN pending-list inconsistency.

```text
ERROR:  could not find additional pending pages for same heap tuple
```

## Related

- [could not find parent of block in lookup table](./could-not-find-parent-of-block-in-lookup-table.md)
- [could not find left sibling of block in index](./could-not-find-left-sibling-of-block-in-index.md)
