---
message: "ending block number must be between 0 and %u"
slug: ending-block-number-must-be-between-0-and
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/amcheck/verify_heapam.c:402"
reproduced: false
---

# `ending block number must be between 0 and %u`

## What it means

An `amcheck` heap-verification function was given an ending block number outside the relation's valid range. The placeholder is the highest allowed block. The end block must be within the table.

## When it happens

It fires from `verify_heapam()` in the `amcheck` extension when the `endblock` argument exceeds the relation's last block.

## How to fix

Pass an `endblock` between 0 and the relation's last block number. Query the table's size in blocks (`pg_relation_size(rel) / current_setting('block_size')::int`) to find the upper bound, or omit the argument to check the whole table.

## Example

*Illustrative* — an out-of-range endblock.

```sql
SELECT * FROM verify_heapam('t', endblock => 1000000);
-- ending block number must be between 0 and 42
```

## Related

- [end block out of bounds](./end-block-out-of-bounds.md)
- [end of tuple reached without looking at all its data](./end-of-tuple-reached-without-looking-at-all-its-data.md)
