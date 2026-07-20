---
message: "\"%s\" is not a BRIN index"
slug: is-not-a-brin-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/access/brin/brin.c:1450"
  - "postgres/src/backend/access/brin/brin.c:1539"
reproduced: false
---

# `"%s" is not a BRIN index`

## What it means

A BRIN-specific operation was given an index that is not a BRIN index. The placeholder names the index. BRIN maintenance functions only work on BRIN indexes.

## When it happens

It arises from BRIN functions such as `brin_summarize_new_values`, `brin_desummarize_range`, or `pageinspect` BRIN helpers when the index argument uses a different access method.

## How to fix

Pass a BRIN index to these functions. Check the index's access method with `\d indexname` or via `pg_am`. If you meant to summarize a different index type, use the maintenance appropriate to that method.

## Example

*Illustrative* — a BRIN function on a btree index.

```sql
SELECT brin_summarize_new_values('my_btree_idx');  -- not a BRIN index
```

## Related

- [index is not a btree](./index-is-not-a-btree.md)
- [is not an index for table](./is-not-an-index-for-table.md)
