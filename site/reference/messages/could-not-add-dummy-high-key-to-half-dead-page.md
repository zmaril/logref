---
message: "could not add dummy high key to half-dead page"
slug: could-not-add-dummy-high-key-to-half-dead-page
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtxlog.c:780"
  - "postgres/src/backend/access/nbtree/nbtxlog.c:914"
reproduced: false
---

# `could not add dummy high key to half-dead page`

## What it means

Internal / recovery error. During B-tree page deletion (or its WAL replay), the code could not place the placeholder high key on a page being marked half-dead. It is a low-level step in the multi-phase page-deletion protocol that failed unexpectedly.

## When it happens

It should not occur in normal operation. Reaching it points to an internal problem during B-tree page deletion or WAL replay, possibly alongside index corruption or an interrupted operation.

## How to fix

Treat it as an internal error. Preserve the server log around the event. If it recurs on a specific index, verify it with `amcheck` and `REINDEX` if it appears damaged, and investigate any preceding crash or storage fault. Report reproducible cases.

## Example

*Illustrative* — emitted internally during B-tree page deletion.

```text
ERROR:  could not add dummy high key to half-dead page
```

## Related

- [could not add new bloom tuple to empty page](./could-not-add-new-bloom-tuple-to-empty-page.md)
- [concurrent GiST page split was incomplete](./concurrent-gist-page-split-was-incomplete.md)
