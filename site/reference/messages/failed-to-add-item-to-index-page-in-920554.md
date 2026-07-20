---
message: "failed to add item to index page in %u/%u/%u"
slug: failed-to-add-item-to-index-page-in-920554
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gin/ginxlog.c:103"
reproduced: false
---

# `failed to add item to index page in %u/%u/%u`

## What it means

An internal guard in GIN index WAL replay. Reconstructing a GIN index page during recovery, the code could not place an item onto it. The placeholders identify the relation file (tablespace, database, and relation numbers).

## When it happens

It fires during recovery or WAL replay of a GIN index change. It generally signals damaged WAL or an on-disk inconsistency in the index rather than a user action.

## How to fix

This is an internal invariant tied to recovery. Confirm the WAL stream is intact and storage is healthy. Once the server is up, rebuild the affected GIN index with `REINDEX`. If recovery cannot complete or it recurs, investigate storage integrity and consider a restore from a known-good backup; capture the details and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  failed to add item to index page in 1663/16384/24576
```

## Related

- [failed to add item to GiST index page, item out of, size bytes](./failed-to-add-item-to-gist-index-page-item-out-of-size-bytes.md)
- [failed to add item to the index page](./failed-to-add-item-to-the-index-page.md)
