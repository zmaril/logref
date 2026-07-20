---
message: "invalid index offnum: %u"
slug: invalid-index-offnum
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/page/bufpage.c:1087"
  - "postgres/src/backend/storage/page/bufpage.c:1328"
  - "postgres/src/backend/storage/page/bufpage.c:1440"
reproduced: false
---

# `invalid index offnum: %u`

## What it means

Internal error. Code that walks the item pointers on an index page was handed an offset number that does not point at a valid line pointer on the page. It is a bounds check on internal page access.

## When it happens

It should not occur in normal operation. Reaching it points to index-page corruption or an internal inconsistency in the access method, not to anything in your query.

## How to fix

Treat it as a corruption or internal-bug signal. Identify the index from surrounding log context, `REINDEX` it, and check storage health. If reindexing clears it, the on-disk index was damaged; if it recurs, capture the details and report it.

## Example

*Illustrative* — emitted while scanning an index page.

```text
ERROR:  invalid index offnum: 512
```

## Related

- [invalid max offset number](./invalid-max-offset-number.md)
- [tuple offset out of range](./tuple-offset-out-of-range.md)
