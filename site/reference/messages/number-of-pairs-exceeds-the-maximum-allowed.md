---
message: "number of pairs (%d) exceeds the maximum allowed (%d)"
slug: number-of-pairs-exceeds-the-maximum-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/contrib/hstore/hstore_io.c:522"
  - "postgres/contrib/hstore/hstore_io.c:639"
  - "postgres/contrib/hstore/hstore_io.c:766"
  - "postgres/contrib/hstore/hstore_op.c:99"
reproduced: false
---

# `number of pairs (%d) exceeds the maximum allowed (%d)`

## What it means

An `hstore` value was built with more key/value pairs than the type's internal format can address. The placeholders are the actual count and the maximum. `hstore` stores its entries with a fixed-width count field, so a single value cannot hold more pairs than that field can represent.

## When it happens

Constructing an enormous `hstore` in one value — typically from `hstore(array, array)` or `hstore(record)` over a very large input — so the pair count exceeds the format limit.

## How to fix

Split the data across multiple `hstore` values or rows rather than packing it all into one. If you are modeling many attributes per entity, reconsider whether `hstore` is the right container; `jsonb` has a much larger practical capacity for large documents.

## Example

*Illustrative* — far too many pairs in one hstore.

```text
ERROR:  number of pairs (100000000) exceeds the maximum allowed (...)
```

## Related

- [array must have two columns](./array-must-have-two-columns.md)
- [can't extend cube](./can-t-extend-cube.md)
