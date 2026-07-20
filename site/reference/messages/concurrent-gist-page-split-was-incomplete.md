---
message: "concurrent GiST page split was incomplete"
slug: concurrent-gist-page-split-was-incomplete
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gist/gist.c:257"
  - "postgres/src/backend/access/gist/gist.c:963"
reproduced: false
---

# `concurrent GiST page split was incomplete`

## What it means

Internal / recovery message. While traversing a GiST index, a backend found a page split that another process had begun but not yet finished linking. GiST handles this by completing the split, but the condition is reported. It reflects concurrency in GiST maintenance, not user error.

## When it happens

During GiST index access or WAL replay when a page split was interrupted (for example by a crash) and left the index in a transiently incomplete state that the reader must fix up.

## How to fix

Usually no action is needed — Postgres completes the incomplete split. If it recurs persistently or is accompanied by other index errors, verify the GiST index with `amcheck` where supported and `REINDEX` it if it appears damaged. Investigate any preceding crash that could have left splits unfinished.

## Example

*Illustrative* — an incomplete GiST split encountered during traversal.

```text
ERROR:  concurrent GiST page split was incomplete
```

## Related

- [could not add dummy high key to half-dead page](./could-not-add-dummy-high-key-to-half-dead-page.md)
- [could not add new bloom tuple to empty page](./could-not-add-new-bloom-tuple-to-empty-page.md)
