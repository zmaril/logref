---
message: "failed to add BRIN tuple to new page"
slug: failed-to-add-brin-tuple-to-new-page
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/brin/brin_pageops.c:255"
  - "postgres/src/backend/access/brin/brin_pageops.c:412"
reproduced: false
---

# `failed to add BRIN tuple to new page`

## What it means

Internal error. The BRIN access method could not place an item onto a new BRIN page, even though its own bookkeeping said the item should fit. It is a consistency guard: index maintenance reached a state it treats as impossible.

## When it happens

It fires during BRIN index maintenance or WAL replay when the on-page free space did not match what the code computed. Ordinary queries do not raise it; it can accompany index or page corruption.

## How to fix

Treat it as possible index damage. Reindex the affected index. If it recurs, check storage health and capture the index name and a reproducible case for a bug report.

## Example

*Illustrative* — a BRIN summary tuple did not fit a fresh page.

```text
ERROR:  failed to add BRIN tuple to new page
```

## Related

- [failed to add item to index page](./failed-to-add-item-to-index-page.md)
- [failed to add index item to](./failed-to-add-index-item-to.md)
