---
message: "failed to add index item to \"%s\""
slug: failed-to-add-index-item-to
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/hash/hashinsert.c:316"
  - "postgres/src/backend/access/hash/hashinsert.c:356"
reproduced: false
---

# `failed to add index item to "%s"`

## What it means

Internal error. The hash access method could not place an index item onto a page it had prepared. The `%s` is the index name. It is a consistency guard in hash-index maintenance.

## When it happens

It fires during hash-index insertion when a page did not have the space the code expected. Ordinary queries do not raise it; it can accompany index or page corruption.

## How to fix

Reindex the affected hash index. If it recurs, check storage health and capture the index name and a reproducible case for a bug report.

## Example

*Illustrative* — a hash index item did not fit.

```text
ERROR:  failed to add index item to "my_hash_idx"
```

## Related

- [failed to add item to index page](./failed-to-add-item-to-index-page.md)
- [failed to add BRIN tuple to new page](./failed-to-add-brin-tuple-to-new-page.md)
