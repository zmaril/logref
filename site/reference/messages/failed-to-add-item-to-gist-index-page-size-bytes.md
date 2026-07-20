---
message: "failed to add item to GiST index page, size %zu bytes"
slug: failed-to-add-item-to-gist-index-page-size-bytes
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gist/gistxlog.c:102"
  - "postgres/src/backend/access/gist/gistxlog.c:137"
reproduced: false
---

# `failed to add item to GiST index page, size %zu bytes`

## What it means

Internal error. The GiST access method could not place an item onto a GiST index page, even though its own bookkeeping said the item should fit. It is a consistency guard: index maintenance reached a state it treats as impossible.

## When it happens

It fires during GiST index maintenance or WAL replay when the on-page free space did not match what the code computed. Ordinary queries do not raise it; it can accompany index or page corruption.

## How to fix

Treat it as possible index damage. Reindex the affected index. If it recurs, check storage health and capture the index name and a reproducible case for a bug report.

## Example

*Illustrative* — a GiST item did not fit during replay.

```text
ERROR:  failed to add item to GiST index page, size 200 bytes
```

## Related

- [failed to add item to index page](./failed-to-add-item-to-index-page.md)
- [inconsistent point values](./inconsistent-point-values.md)
