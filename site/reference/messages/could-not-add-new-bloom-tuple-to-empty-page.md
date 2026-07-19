---
message: "could not add new bloom tuple to empty page"
slug: could-not-add-new-bloom-tuple-to-empty-page
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/bloom/blinsert.c:104"
  - "postgres/contrib/bloom/blinsert.c:324"
reproduced: false
---

# `could not add new bloom tuple to empty page`

## What it means

Internal error. The `bloom` index access method tried to place a new index tuple on a freshly initialized (empty) page and the insert did not succeed. On an empty page the tuple must always fit, so failing points to an internal inconsistency.

## When it happens

It should not occur in normal operation. Reaching it points to an internal problem in the bloom extension's page handling, not to anything in your data or query.

## How to fix

Treat it as an internal bug in the `bloom` extension. Capture the index definition and the operation that triggered it and report it. Rebuilding the index with `REINDEX` is worth trying if the same index keeps failing.

## Example

*Illustrative* — emitted internally by the bloom index.

```text
ERROR:  could not add new bloom tuple to empty page
```

## Related

- [could not add dummy high key to half-dead page](./could-not-add-dummy-high-key-to-half-dead-page.md)
- [concurrent GiST page split was incomplete](./concurrent-gist-page-split-was-incomplete.md)
