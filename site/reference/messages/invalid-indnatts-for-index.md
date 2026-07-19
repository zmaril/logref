---
message: "invalid indnatts %d for index %u"
slug: invalid-indnatts-for-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:2456"
  - "postgres/src/backend/catalog/index.c:2516"
reproduced: false
---

# `invalid indnatts %d for index %u`

## What it means

Internal error. An index's stored count of key/included attributes (`indnatts`) is out of range for the index. The placeholders are the bad count and the index OID. It is a consistency guard over `pg_index`.

## When it happens

It fires when index-support code reads `pg_index` and finds `indnatts` zero or larger than the maximum. Ordinary queries do not surface it; it points to damaged index catalog metadata.

## How to fix

This is a can't-happen guard. Try `REINDEX INDEX` to rebuild the index; if the catalog row itself is bad, that may not suffice and the index may need dropping and recreating. Report a reproducible case and check for catalog corruption.

## Example

*Illustrative* — an index with an impossible attribute count.

```text
ERROR:  invalid indnatts 0 for index 16418
```

## Related

- [invalid attnum for relation](./invalid-attnum-for-relation.md)
- [index is not a btree](./index-is-not-a-btree.md)
